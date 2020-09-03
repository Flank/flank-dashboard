const firestore = require("firebase").firestore;
const cloneDeep = require("clone-deep");

/** A list of test project groups */
const projectGroups = {
  "project_groups/1": {
    name: "project_group_1",
    projectIds: ["1", "2"],
  },
  "project_groups/2": {
    name: "project_group_2",
    projectIds: ["1"],
  },
};

/** A list of test builds */
const builds = {
  "build/1": {
    projectId: "1",
    buildNumber: 1,
    startedAt: new firestore.Timestamp.now(),
    buildStatus: "BuildStatus.failed",
    workflowName: "workflow",
    duration: 234,
    url: "url1",
    coverage: 0.0,
  },
  "build/2": {
    projectId: "2",
    buildNumber: 1,
    startedAt: new firestore.Timestamp.now(),
    buildStatus: "BuildStatus.cancelled",
    workflowName: "workflow",
    duration: 345,
    url: "url2",
    coverage: 1.0,
  },
};

/** A list of test allowed email domains */
const allowedEmailDomains = {
  "allowed_email_domains/gmail.com": {},
};

const allowedDomainEmail = "test@gmail.com";
const notAllowedDomainEmail = "test@invalid.com";

/** Creates a firebase user with the given `email` and `signInProviderId` */
function getUser(email, signInProviderId) {
  return {
    uid: "uid",
    email: email,
    firebase: {
      sign_in_provider: signInProviderId,
    },
  };
}

/** A test project */
exports.project = {
  name: "test_project",
};

/** A list of test projects */
exports.projects = {
  "projects/1": {
    name: "project_1",
  },
  "projects/2": {
    name: "project_2",
  },
};

exports.projectGroups = projectGroups;
exports.builds = builds;
exports.allowedEmailDomains = allowedEmailDomains;

/** An email and password sign in provider identifier */
exports.passwordSignInProviderId = "password";

/** A google sign in provider identifier */
exports.gleSignInProviderId = "google.com";

/** Provides a firebase user with allowed email domain and given sign in provider identifier */
exports.getAllowedEmailDomainUser = function (signInProviderId) {
  return getUser(allowedDomainEmail, signInProviderId);
};

/** Provides a firebase user with not allowed email domain and given sign in provider identifier */
exports.getNotAllowedDomainUser = function (signInProviderId) {
  return getUser(notAllowedDomainEmail, signInProviderId);
};

/** Get a test project group */
exports.getProjectGroup = function () {
  return cloneDeep(projectGroups["project_groups/1"]);
};

/** Get a test build */
exports.getBuild = function () {
  return cloneDeep(builds["build/1"]);
};
