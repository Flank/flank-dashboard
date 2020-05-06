import { initializeTestApp, loadFirestoreRules } from '@firebase/testing';
import { readFileSync } from 'fs';

export async function setup(auth, data) {
    const projectId = `rules-spec-${Date.now()}`;
    const app = await initializeTestApp({
        projectId,
        auth
    });

    const db = app.firestore();

    // Write mock documents before rules
    if (data) {
        for (const key in data) {
            const ref = db.doc(key);
            await ref.set(data[key]);
        }
    }

    // Apply rules
    await loadFirestoreRules({
        projectId,
        rules: readFileSync('firestore.rules', 'utf8')
    });

    return db;
}

module.exports.teardown = async () => {
    Promise.all(firebase.apps().map(app => app.delete()));
};
