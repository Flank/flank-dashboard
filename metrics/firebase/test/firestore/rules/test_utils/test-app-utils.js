// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const {
  initializeTestApp,
  initializeAdminApp,
  loadFirestoreRules,
  apps, assertSucceeds, assertFails,
} = require("@firebase/rules-unit-testing");

const { readFileSync } = require("fs");
const async = require("async");
const projectId = `rules-spec-${Date.now()}`;
const featureConfigPath = "feature_config/feature_config";
const collectionsWithPublicDashboardTests = ["project_groups","projects","build_days","build","user_profiles"];

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

/** Tests security rules with public dashboard feature. */
exports.userPermissionsTest = async function (usersPermissions, config, collection, addValue, updateValue){
  async.forEach(usersPermissions, (user, callback) => {
    describe(user.describe, () => {
      let publicDashboardState = '';
      let userPath;

      if(collectionsWithPublicDashboardTests.find(e => e === collection) !== undefined){
        publicDashboardState = config[featureConfigPath].isPublicDashboardEnabled
          ? 'on'
          : 'off';
        userPath = user.public_dashboard[publicDashboardState];
      }
      else {
        userPath = user;
      }


      let canCreateDescription = userPath.can.create ?
        "allows creating a build day" : "does not allow creating a build day";
      let canReadDescription = userPath.can.read ?
        "allows reading build days" : "does not allow reading build days";
      let canUpdateDescription = userPath.can.update ?
        "allows updating a build day" : "does not allow updating a build day";
      let canDeleteDescription = userPath.can.delete ?
        "allows deleting a build day" : "does not allow deleting a build day";

      it(canCreateDescription, async () => {
        const createPromise = user.app.collection(collection).add(addValue);

        if (userPath.can.create) {
          await assertSucceeds(createPromise)
        } else {
          await assertFails(createPromise)
        }
      });

      it(canReadDescription, async () => {
        const readPromise = user.app.collection(collection).get();

        if (userPath.can.read) {
          await assertSucceeds(readPromise)
        } else {
          await assertFails(readPromise)
        }
      });

      it(canUpdateDescription, async () => {
        const updatePromise =
          user.app.collection(collection).doc("1").update(updateValue);

        if (userPath.can.update) {
          await assertSucceeds(updatePromise)
        } else {
          await assertFails(updatePromise)
        }
      });

      it(canDeleteDescription, async () => {
        const deletePromise =
          user.app.collection(collection).doc("1").delete();

        if (userPath.can.delete) {
          await assertSucceeds(deletePromise)
        } else {
          await assertFails(deletePromise)
        }
      });
    });
    callback();
  });
};
