// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const {
  initializeTestApp,
  initializeAdminApp,
  loadFirestoreRules,
  apps,
} = require("@firebase/rules-unit-testing");

const { readFileSync } = require("fs");
const projectId = `rules-spec-${Date.now()}`;

/** Constructs an application with the given user. */
exports.getApplicationWith = async function (user) {
  const app = await initializeTestApp({
    projectId,
    auth: user,
  });

  return app.firestore();
};

/** Creates an admin app with security rules using initial data. */
exports.setupTestDatabaseWith = async function (initialData) {
  const adminApp = await initializeAdminApp({ projectId });

  if (initialData) {
    for (const key in initialData) {
      const ref = adminApp.firestore().doc(key);
      await ref.set(initialData[key]);
    }
  }

  await loadFirestoreRules({
    projectId,
    rules: readFileSync(
      __dirname + "/../../../../firestore/rules/firestore.rules",
      "utf8"
    ),
  });
};

/** Deletes the application and frees the resources of all associated services. */
exports.tearDown = async () => {
  return Promise.all(apps().map((app) => app.delete()));
};
