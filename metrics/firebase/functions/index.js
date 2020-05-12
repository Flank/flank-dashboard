const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);
const settings = { timestampsInSnapshots: true };
admin.firestore().settings(settings);

/// List of available build statuses.
const buildStatuses = ['BuildStatus.successful', 'BuildStatus.cancelled', 'BuildStatus.failed'];

/* eslint-disable no-await-in-loop */

/// Creates seed builds for metrics projects.
///
/// This HTTP function takes such query params: 
/// buildsCount (required) - number of builds to be generated.
/// projectId (required) - the project identifier for which builds will be generated.
/// startDate (optional) - builds will be generated with startedAt property
/// in range from startDate to startDate - 7 days. Defaults to current date.
/// delay (optional) - is the delay in milliseconds between adding builds to project
exports.seedData = functions.https.onRequest(async (req, resp) => {
    /// Change to enable this function.
    const inactive = true;

    if (inactive){
     return resp.status(200).send('done');
    }

    const buildsCount = req.query['buildsCount'];
    const projectId = req.query['projectId'];
    const startDateString = req.query['startDate'];
    const delay = req.query['delay'];

    if (!buildsCount || !projectId) {
        return resp.status(400).send("'buildsCount' and 'projectId' are required query parameters and could not be empty.");
    }

    var startDate;

    if (startDateString) {
        startDate = new Date(startDateString);
        console.log(startDate);
    } else {
        startDate = new Date();
    }

    let endDate = new Date();
    endDate.setDate(startDate.getDate() - 7);

    let minDuration = 10 * 60 * 1000;
    let maxDuration = 30 * 60 * 1000;

    console.log(`Creating ${buildsCount} builds in ${projectId}...`);

    for (var i = 0; i < buildsCount; i++) {
        let buildDate = randomDate(startDate, endDate);
        let duration = randomInt(minDuration, maxDuration);

        await new Promise(resolve => setTimeout(resolve, delay));

        await admin.firestore().collection('build').doc().set({
            duration: duration,
            projectId: projectId,
            buildStatus: buildStatuses[randomInt(0, buildStatuses.length)],
            startedAt: buildDate,
            coverage: Math.round(Math.random() * 100) / 100,
            url: 'https://github.com/software-platform/monorepo/commits/master',
            workflowName: 'run_tests',
        });
    }
    return resp.status(200).send('done');
}
);

/// Creates random Date in the range from start to end.
function randomDate(start, end) {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
}

/// Creates random integer in the range from start to end.
function randomInt(from, to) {
    return Math.floor(from + Math.random() * (to - from));
}