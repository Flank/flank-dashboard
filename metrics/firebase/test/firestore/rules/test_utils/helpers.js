const {
  initializeTestApp,
  initializeAdminApp,
  loadFirestoreRules,
  apps,
} = require("@firebase/testing");

const { readFileSync } = require("fs");
const projectId = `rules-spec-${Date.now()}`;

// Construct an application with the given auth options
exports.getApplication = async function (auth) {
  const app = await initializeTestApp({
    projectId,
    auth,
  });

  return app.firestore();
};

exports.setupTestDatabase = async function (initialData) {
  const adminApp = await initializeAdminApp({ projectId });

  if (initialData) {
    for (const key in initialData) {
      const ref = adminApp.firestore().doc(key);
      await ref.set(initialData[key]);
    }
  }

  // Apply rules
  await loadFirestoreRules({
    projectId,
    rules: readFileSync(
      __dirname + "/../../../../firestore/rules/firestore.rules",
      "utf8"
    ),
  });
};

// Deletes the app and frees the resources of all associated services.
exports.tearDown = async () => {
  Promise.all(apps().map((app) => app.delete()));
};
