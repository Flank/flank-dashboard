// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const dartFunctions = require('./build/packages/functions/main.dart.js');

admin.initializeApp(functions.config().firebase);
const settings = { timestampsInSnapshots: true };
admin.firestore().settings(settings);

/**
 * A list of available build statuses.
 */
const buildStatuses = ['BuildStatus.successful', 'BuildStatus.unknown', 'BuildStatus.failed'];

/* eslint-disable no-await-in-loop */


/**
 * Creates seed builds for metrics projects.
 *
 * This HTTP function takes such query params:
 * @param {number} buildsCount required - number of builds to be generated.
 * @param {number} projectId (required) - the project identifier for which builds will be generated.
 * @param {number} startDate (optional) - builds will be generated with startedAt property
 * in range from startDate to startDate - 7 days. Defaults to current date.
 * @param {number} delay (optional) - is the delay in milliseconds between adding builds to project
 */
exports.seedData = functions.https.onRequest(async (req, resp) => {
    /// Change to enable this function.
    const inactive = true;

    if (inactive) {
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
            url: 'https://github.com/Flank/flank-dashboard/commits/master',
            workflowName: 'run_tests',
        });
    }
    return resp.status(200).send('done');
}
);

/**
 * Checks whether the email domain is in the allowed domains list.
 *
 * @param {Object} data - a request object that accepts such fields:
 * - `emailDomain` - the email domain to validate.
 *
 * @return {Object} containing such fields:
 * - `isValid` - indicates whether the email domain from the request is a valid or not.
 */
exports.validateEmailDomain = functions.https.onCall(async (data, context) => {
    let requestData = data || {};
    let userEmailDomain = requestData.emailDomain || '';
    let isValid = false;

    if (userEmailDomain) {
        let allowedDomainSnapshot = await admin.firestore()
            .collection('allowed_email_domains')
            .doc(userEmailDomain)
            .get();

        isValid = allowedDomainSnapshot.exists;
    }

    return {
        "isValid": isValid,
    }
});

/**
 * Creates random Date in the range from start to end.
 */
function randomDate(start, end) {
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
}

/**
 * Creates random integer in the range from start to end.
 */
function randomInt(from, to) {
    return Math.floor(from + Math.random() * (to - from));
}

exports.onBuildAdded = dartFunctions.onBuildAdded;
exports.onBuildUpdated = dartFunctions.onBuildUpdated;
