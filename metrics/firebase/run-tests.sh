#!/bin/bash

firebase emulators:exec --only firestore "npm run test"
