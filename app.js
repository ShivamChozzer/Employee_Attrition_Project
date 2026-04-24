async function loadJson(path) {
  const res = await fetch(path, { cache: "no-store" });
  if (!res.ok) throw new Error(`Failed to load ${path}: ${res.status}`);
  return await res.json();
}

function argMax(arr) {
  let bestI = 0;
  let bestV = arr[0] ?? -Infinity;
  for (let i = 1; i < arr.length; i++) {
    if (arr[i] > bestV) {
      bestV = arr[i];
      bestI = i;
    }
  }
  return bestI;
}

function predictDecisionTree(model, x) {
  let node = 0;
  while (true) {
    const f = model.feature[node];
    if (f === -2) {
      const probs = model.value[node]; // [p(class0), p(class1)]
      return argMax(probs);
    }
    const thr = model.threshold[node];
    node = x[f] <= thr ? model.children_left[node] : model.children_right[node];
    if (node < 0) throw new Error("Corrupt tree traversal.");
  }
}

function encode(encoders, field, value) {
  const classes = encoders[field];
  const idx = classes.indexOf(value);
  if (idx === -1) {
    throw new Error(`Invalid value '${value}' for ${field}.`);
  }
  return idx;
}

function toNumber(name, v) {
  const n = Number(v);
  if (!Number.isFinite(n)) throw new Error(`Invalid number for ${name}.`);
  return n;
}

async function main() {
  const [model, encoders] = await Promise.all([
    loadJson("./model.json"),
    loadJson("./encoders.json"),
  ]);

  const form = document.getElementById("attritionForm");
  const result = document.getElementById("result");
  const predictBtn = document.getElementById("predictBtn");
  const resetBtn = document.getElementById("resetBtn");

  resetBtn.addEventListener("click", () => {
    form.reset();
    result.className = "result muted";
    result.textContent = "Fill the form and click Predict.";
  });

  form.addEventListener("submit", (e) => {
    e.preventDefault();

    try {
      predictBtn.disabled = true;

      const fd = new FormData(form);
      const raw = Object.fromEntries(fd.entries());

      // Must match model.feature_order
      const x = [
        toNumber("Age", raw.Age),
        encode(encoders, "BusinessTravel", raw.BusinessTravel),
        encode(encoders, "Department", raw.Department),
        toNumber("DistanceFromHome", raw.DistanceFromHome),
        toNumber("Education", raw.Education),
        encode(encoders, "Gender", raw.Gender),
        encode(encoders, "JobRole", raw.JobRole),
        encode(encoders, "MaritalStatus", raw.MaritalStatus),
        toNumber("MonthlyIncome", raw.MonthlyIncome),
        toNumber("YearsAtCompany", raw.YearsAtCompany),
      ];

      const pred = predictDecisionTree(model, x); // 0 or 1
      const isAttrition = pred === 1;

      result.className = isAttrition ? "result is-bad" : "result is-ok";
      result.innerHTML = isAttrition
        ? `Prediction: <span class="bad">Attrition likely</span> (class = 1)`
        : `Prediction: <span class="ok">No attrition likely</span> (class = 0)`;
    } catch (err) {
      result.className = "result is-error";
      result.innerHTML = `Error: <span class="bad">${String(err.message || err)}</span>`;
    } finally {
      predictBtn.disabled = false;
    }
  });
}

main().catch((err) => {
  const result = document.getElementById("result");
  if (result) {
    result.className = "result";
    result.innerHTML = `Error: <span class="bad">${String(err.message || err)}</span>`;
  }
});

