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

/** A list of test builds */
const builds = {
  "build/1": {
    projectId: "1",
    startedAt: new firestore.Timestamp.now(),
    duration: 234,
    url: "url1",
  },
  "build/2": {
    projectId: "2",
    startedAt: new firestore.Timestamp.now(),
    duration: 345,
    url: "url2",
  },
};

exports.builds = builds;

/** A firebase user needed for tests */
exports.user = { uid: "uid" };

/** Get a test build */
exports.getBuild = function () {
  return Object.assign({}, builds["build/1"]);
};
