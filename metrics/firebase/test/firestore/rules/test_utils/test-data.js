const firestore = require("firebase").firestore;

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

exports.projectGroups = projectGroups;
exports.builds = builds;

/** A firebase user needed for tests */
exports.user = { uid: "uid" };

/** Get a test project group */
exports.getProjectGroup = function () {
  return clone(projectGroups["project_groups/1"]);
};

/** Get a test build */
exports.getBuild = function () {
  return Object.assign({}, builds["build/1"]);
};

/** Returns a deep copy of the given value  */
function clone(value) {
  return JSON.parse(JSON.stringify(value));
}
