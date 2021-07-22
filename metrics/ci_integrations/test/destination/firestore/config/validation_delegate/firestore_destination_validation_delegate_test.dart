// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/mappers/firestore_exception_reason_mapper.dart';
import 'package:ci_integration/client/firestore/models/firebase_auth_credentials.dart';
import 'package:ci_integration/destination/firestore/config/model/firestore_destination_validation_target.dart';
import 'package:ci_integration/destination/firestore/config/validation_delegate/firestore_destination_validation_delegate.dart';
import 'package:ci_integration/destination/firestore/factory/firebase_auth_factory.dart';
import 'package:ci_integration/destination/firestore/factory/firestore_factory.dart';
import 'package:ci_integration/destination/firestore/strings/firestore_strings.dart';
import 'package:ci_integration/integration/validation/model/config_field_validation_conclusion.dart';
import 'package:firedart/firedart.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matchers.dart';
import '../../test_utils/mock/firebase_auth_mock.dart';
import '../../test_utils/test_data/collection_reference_mock.dart';
import '../../test_utils/test_data/document_mock.dart';
import '../../test_utils/test_data/document_reference_mock.dart';
import '../../test_utils/test_data/firestore_mock.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("FirestoreDestinationValidationDelegate", () {
    const apiKey = 'key';
    const email = 'stub@email.com';
    const password = 'stub_password';
    const message = 'message';
    const projectId = 'id';
    const metricsProjectId = 'id';
    const projectsCollectionName = 'projects';
    const stubDocumentName = 'id';

    const invalidApiKeyAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.invalidApiKey,
      message,
    );
    const emailNotFoundAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.emailNotFound,
      message,
    );
    const invalidPasswordAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.invalidPassword,
      message,
    );
    const passwordLoginDisabledAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.passwordLoginDisabled,
      message,
    );
    const userDisabledAuthException = FirebaseAuthException(
      FirebaseAuthExceptionCode.userDisabled,
      message,
    );

    final credentials = FirebaseAuthCredentials(
      apiKey: apiKey,
      email: email,
      password: password,
    );

    final user = User.fromMap(const {});

    final authFactory = _FirebaseAuthFactoryMock();
    final firestoreFactory = _FirestoreFactoryMock();
    final firebaseAuth = FirebaseAuthMock();
    final firestore = FirestoreMock();
    final collection = CollectionReferenceMock();
    final documentReference = DocumentReferenceMock();
    final document = DocumentMock();

    final delegate = FirestoreDestinationValidationDelegate(
      authFactory,
      firestoreFactory,
    );

    FirestoreException createFirestoreException({
      FirestoreExceptionCode code,
      List<String> reasons,
      String message,
    }) {
      return FirestoreException(code, reasons, message);
    }

    final consumerInvalidFirestoreException = createFirestoreException(
      reasons: [FirestoreExceptionReasonMapper.consumerInvalid],
    );
    final notFoundFirestoreException = createFirestoreException(
      reasons: [FirestoreExceptionReasonMapper.notFound],
    );
    final projectInvalidFirestoreException = createFirestoreException(
      reasons: [FirestoreExceptionReasonMapper.projectInvalid],
    );
    final projectDeletedFirestoreException = createFirestoreException(
      reasons: [FirestoreExceptionReasonMapper.projectDeleted],
    );

    PostExpectation<FirebaseAuth> whenCreateFirebaseAuth() {
      return when(authFactory.create(apiKey));
    }

    PostExpectation<Future<User>> whenSignIn({
      String withEmail = email,
      String withPassword = password,
    }) {
      whenCreateFirebaseAuth().thenReturn(firebaseAuth);

      return when(firebaseAuth.signIn(withEmail, withPassword));
    }

    PostExpectation<Firestore> whenCreateFirestore() {
      whenSignIn().thenAnswer((_) => Future.value(user));

      return when(firestoreFactory.create(projectId, firebaseAuth));
    }

    PostExpectation<CollectionReference> whenCollection({
      String withName,
    }) {
      whenCreateFirestore().thenReturn(firestore);

      return when(firestore.collection(withName));
    }

    PostExpectation<DocumentReference> whenDocument({
      String withName,
    }) {
      whenCollection(
        withName: projectsCollectionName,
      ).thenReturn(collection);

      return when(collection.document(withName));
    }

    PostExpectation<Future<Document>> whenGetMetricsProject({
      String withName = metricsProjectId,
    }) {
      whenCollection(
        withName: projectsCollectionName,
      ).thenReturn(collection);
      whenDocument(
        withName: withName,
      ).thenReturn(documentReference);

      return when(documentReference.get());
    }

    PostExpectation<bool> whenMetricsProjectExists() {
      whenGetMetricsProject().thenAnswer((_) => Future.value(document));

      return when(document.exists);
    }

    tearDown(() {
      reset(authFactory);
      reset(firestoreFactory);
      reset(firebaseAuth);
      reset(firestore);
      reset(collection);
      reset(documentReference);
      reset(document);
    });

    test(
      "throws an ArgumentError if the given auth factory is null",
      () {
        expect(
          () => FirestoreDestinationValidationDelegate(null, firestoreFactory),
          throwsArgumentError,
        );
      },
    );

    test(
      "throws an ArgumentError if the given Firestore factory is null",
      () {
        expect(
          () => FirestoreDestinationValidationDelegate(authFactory, null),
          throwsArgumentError,
        );
      },
    );

    test(
      "creates an instance with the given parameters",
      () {
        final validationDelegate = FirestoreDestinationValidationDelegate(
          authFactory,
          firestoreFactory,
        );

        expect(validationDelegate.authFactory, equals(authFactory));
        expect(validationDelegate.firestoreFactory, equals(firestoreFactory));
      },
    );

    test(
      ".validatePublicApiKey() creates a firebase auth using the firebase auth factory",
      () {
        whenCreateFirebaseAuth().thenReturn(firebaseAuth);

        delegate.validatePublicApiKey(apiKey);

        verify(authFactory.create(apiKey)).called(once);
      },
    );

    test(
      ".validatePublicApiKey() signs in using the created firebase auth",
      () {
        whenCreateFirebaseAuth().thenReturn(firebaseAuth);

        delegate.validatePublicApiKey(apiKey);

        verify(firebaseAuth.signIn(any, any)).called(once);
      },
    );

    test(
      ".validatePublicApiKey() returns a target validation result with a firestore public api key validation target if the auth throws a firebase auth exception with the 'invalid api key' code",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validatePublicApiKey(apiKey);
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebasePublicApiKey),
        );
      },
    );

    test(
      ".validatePublicApiKey() returns a target validation result with an invalid config field validation conclusion if the auth throws a firebase auth exception with the 'invalid api key' code",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validatePublicApiKey(apiKey);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validatePublicApiKey() returns a target validation result with the 'api key invalid' description if the auth throws a firebase auth exception with the 'invalid api key' code",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validatePublicApiKey(apiKey);

        expect(
          result.description,
          equals(FirestoreStrings.apiKeyInvalid),
        );
      },
    );

    test(
      ".validatePublicApiKey() returns a target validation result with a firestore public api key validation target if the auth throws a firebase auth exception with the code does not indicate that the api key is invalid",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer((_) => Future.error(emailNotFoundAuthException));

        final result = await delegate.validatePublicApiKey(apiKey);
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebasePublicApiKey),
        );
      },
    );

    test(
      ".validatePublicApiKey() returns a target validation result with a valid config field validation conclusion if the auth throws a firebase auth exception with the code does not indicate that the api key is invalid",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer((_) => Future.error(emailNotFoundAuthException));

        final result = await delegate.validatePublicApiKey(apiKey);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validatePublicApiKey() returns a target validation result with a firestore public api key validation target if the sign-in process finishes successfully",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer((_) => Future.value(user));

        final result = await delegate.validatePublicApiKey(apiKey);
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebasePublicApiKey),
        );
      },
    );

    test(
      ".validatePublicApiKey() returns a target validation result with a valid config field validation conclusion if the sign-in process finishes successfully",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer((_) => Future.value(user));

        final result = await delegate.validatePublicApiKey(apiKey);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateAuth() creates a firebase auth with the firebase auth factory",
      () {
        whenCreateFirebaseAuth().thenReturn(firebaseAuth);

        delegate.validateAuth(credentials);

        verify(authFactory.create(apiKey)).called(once);
      },
    );

    test(
      ".validateAuth() signs in using the created firebase auth and the given credentials",
      () {
        final expectedEmail = credentials.email;
        final expectedPassword = credentials.password;
        whenCreateFirebaseAuth().thenReturn(firebaseAuth);

        delegate.validateAuth(credentials);

        verify(
          firebaseAuth.signIn(expectedEmail, expectedPassword),
        ).called(once);
      },
    );

    test(
      ".validateAuth() returns a target validation result with a firestore user email validation target if the auth throws a firebase auth exception with the 'email not found' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateAuth(credentials);
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseUserEmail),
        );
      },
    );

    test(
      ".validateAuth() returns a target validation result with an invalid config field validation conclusion if the auth throws a firebase auth exception with the 'email not found' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateAuth(credentials);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result containing the exception message if the auth throws a firebase auth exception with the 'email not found' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.description, equals(message));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a firestore user email validation target if the auth throws a firebase auth exception with the 'invalid password' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidPasswordAuthException),
        );

        final result = await delegate.validateAuth(credentials);
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseUserEmail),
        );
      },
    );

    test(
      ".validateAuth() returns a target validation result with an invalid config field validation conclusion if the auth throws a firebase auth exception with the 'invalid password' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidPasswordAuthException),
        );

        final result = await delegate.validateAuth(credentials);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result containing the exception message if the auth throws a firebase auth exception with the 'invalid password' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidPasswordAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.description, equals(message));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a firestore user email validation target if the auth throws a firebase auth exception with the 'password login disabled' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(passwordLoginDisabledAuthException),
        );

        final result = await delegate.validateAuth(credentials);
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseUserEmail),
        );
      },
    );

    test(
      ".validateAuth() returns a target validation result with an invalid config field validation conclusion if the auth throws a firebase auth exception with the 'password login disabled' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(passwordLoginDisabledAuthException),
        );

        final result = await delegate.validateAuth(credentials);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result containing the exception message if the auth throws a firebase auth exception with the 'password login disabled' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(passwordLoginDisabledAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.description, equals(message));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a firestore user email validation target if the auth throws a firebase auth exception with the 'user disabled' code",
      () async {
        whenSignIn().thenAnswer((_) => Future.error(userDisabledAuthException));

        final result = await delegate.validateAuth(credentials);
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseUserEmail),
        );
      },
    );

    test(
      ".validateAuth() returns a target validation result with an invalid config field validation conclusion if the auth throws a firebase auth exception with the 'user disabled' code",
      () async {
        whenSignIn().thenAnswer((_) => Future.error(userDisabledAuthException));

        final result = await delegate.validateAuth(credentials);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateAuth() returns a target validation result containing the exception message if the auth throws a firebase auth exception with the 'user disabled' code",
      () async {
        whenSignIn().thenAnswer((_) => Future.error(userDisabledAuthException));

        final result = await delegate.validateAuth(credentials);

        expect(result.description, equals(message));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a firestore user email validation target if the auth throws a firebase auth exception with the code does not indicate that the auth is invalid",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validateAuth(credentials);
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseUserEmail),
        );
      },
    );

    test(
      ".validateAuth() returns a target validation result with an unknown config field validation conclusion if the auth throws a firebase auth exception with the code does not indicate that the auth is invalid",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validateAuth(credentials);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.unknown));
      },
    );

    test(
      ".validateAuth() returns a target validation result with the 'auth validation failed' description containing the exception code and message if the auth throws a firebase auth exception with the code does not indicate that the auth is invalid",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );
        final expectedDescription = FirestoreStrings.authValidationFailed(
          '${invalidApiKeyAuthException.code}',
          invalidApiKeyAuthException.message,
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.description, equals(expectedDescription));
      },
    );

    test(
      ".validateAuth() returns a target validation result with a firestore user email validation target if the sign-in process finishes successfully",
      () async {
        whenSignIn().thenAnswer((_) => Future.value(user));

        final result = await delegate.validateAuth(credentials);
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseUserEmail),
        );
      },
    );

    test(
      ".validateAuth() returns a target validation result with a valid config field validation conclusion if the sign-in process finishes successfully",
      () async {
        whenSignIn().thenAnswer((_) => Future.value(user));

        final result = await delegate.validateAuth(credentials);
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateFirebaseProjectId() creates a firebase auth using the firebase auth factory",
      () async {
        whenGetMetricsProject(
          withName: stubDocumentName,
        ).thenAnswer((_) => Future.value());

        await delegate.validateFirebaseProjectId(credentials, projectId);

        verify(authFactory.create(apiKey)).called(once);
      },
    );

    test(
      ".validateFirebaseProjectId() signs in using the firebase auth and the given credentials",
      () async {
        final expectedEmail = credentials.email;
        final expectedPassword = credentials.password;
        whenGetMetricsProject(
          withName: stubDocumentName,
        ).thenAnswer((_) => Future.value());

        await delegate.validateFirebaseProjectId(credentials, projectId);

        verify(
          firebaseAuth.signIn(expectedEmail, expectedPassword),
        ).called(once);
      },
    );

    test(
      ".validateFirebaseProjectId() creates a Firestore instance using the Firestore factory",
      () async {
        whenGetMetricsProject(
          withName: stubDocumentName,
        ).thenAnswer((_) => Future.value());

        await delegate.validateFirebaseProjectId(credentials, projectId);

        verify(firestoreFactory.create(projectId, firebaseAuth)).called(once);
      },
    );

    test(
      ".validateFirebaseProjectId() reads a document from the 'projects' collection",
      () async {
        whenGetMetricsProject(
          withName: stubDocumentName,
        ).thenAnswer((_) => Future.value());

        await delegate.validateFirebaseProjectId(credentials, projectId);

        verify(firestore.collection(projectsCollectionName)).called(once);
        verify(collection.document(stubDocumentName)).called(once);
        verify(documentReference.get()).called(once);
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a firestore project id validation target if the Firestore throws a Firestore exception with the 'consumer invalid' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(consumerInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseProjectId),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with an invalid config field validation conclusion if the Firestore throws a Firestore exception with the 'consumer invalid' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(consumerInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with the 'invalid firebase project id' description if the Firestore throws a Firestore exception with the 'consumer invalid' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(consumerInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(
          result.description,
          equals(FirestoreStrings.projectIdInvalid),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a firestore project id validation target if the Firestore throws a Firestore exception with the 'not found' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(notFoundFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseProjectId),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with an invalid config field validation conclusion if the Firestore throws a Firestore exception with the 'not found' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(notFoundFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with the 'invalid firebase project id' description if the Firestore throws a Firestore exception with the 'not found' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(notFoundFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(
          result.description,
          equals(FirestoreStrings.projectIdInvalid),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a firestore project id validation target if the Firestore throws a Firestore exception with the 'project deleted' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(projectDeletedFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseProjectId),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with an invalid config field validation conclusion if the Firestore throws a Firestore exception with the 'project deleted' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(projectDeletedFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with the 'invalid firebase project id' description if the Firestore throws a Firestore exception with the 'project deleted' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(projectDeletedFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(
          result.description,
          equals(FirestoreStrings.projectIdInvalid),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a firestore project id validation target if the Firestore throws a Firestore exception with the 'project invalid' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(projectInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseProjectId),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with an invalid config field validation conclusion if the Firestore throws a Firestore exception with the 'project invalid' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(projectInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with the 'invalid firebase project id' description if the Firestore throws a Firestore exception with the 'project invalid' exception reason",
      () async {
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(projectInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(
          result.description,
          equals(FirestoreStrings.projectIdInvalid),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a firestore project id validation target if the Firebase auth throws during signing in",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseProjectId),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with an unknown config field validation conclusion if the Firebase auth throws during signing in",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.unknown));
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with the 'unknown error when signing in' description if the Firebase auth throws during signing in",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(
          result.description,
          equals(FirestoreStrings.unknownErrorWhenSigningIn),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a firestore project id validation target if the Firestore throws a Firestore exception with empty exception reasons",
      () async {
        final exception = createFirestoreException(reasons: []);
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(exception),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseProjectId),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a valid config field validation conclusion if the Firestore throws a Firestore exception with empty exception reasons",
      () async {
        final exception = createFirestoreException(reasons: []);
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(exception),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a firestore project id validation target if the Firestore throws a Firestore exception with null exception reasons",
      () async {
        final exception = createFirestoreException(reasons: null);
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(exception),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseProjectId),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a valid config field validation conclusion if the Firestore throws a Firestore exception with null exception reasons",
      () async {
        final exception = createFirestoreException(reasons: null);
        whenGetMetricsProject(withName: stubDocumentName).thenAnswer(
          (_) => Future.error(exception),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a firestore project id validation target if reading documents process succeeds",
      () async {
        whenGetMetricsProject(
          withName: stubDocumentName,
        ).thenAnswer((_) => Future.value());

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.firebaseProjectId),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a target validation result with a valid config field validation conclusion if reading documents process succeeds",
      () async {
        whenGetMetricsProject(
          withName: stubDocumentName,
        ).thenAnswer((_) => Future.value());

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );

    test(
      ".validateMetricsProjectId() creates a firebase auth using the firebase auth factory",
      () async {
        whenMetricsProjectExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(authFactory.create(apiKey)).called(once);
      },
    );

    test(
      ".validateMetricsProjectId() signs in using the firebase auth and the given credentials",
      () async {
        final expectedEmail = credentials.email;
        final expectedPassword = credentials.password;
        whenMetricsProjectExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(
          firebaseAuth.signIn(expectedEmail, expectedPassword),
        ).called(once);
      },
    );

    test(
      ".validateMetricsProjectId() creates a Firestore instance using the Firestore factory",
      () async {
        whenMetricsProjectExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(firestoreFactory.create(projectId, firebaseAuth)).called(once);
      },
    );

    test(
      ".validateMetricsProjectId() reads a document from the projects collection with the given metrics project id",
      () async {
        whenMetricsProjectExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(firestore.collection('projects')).called(once);
        verify(collection.document(metricsProjectId)).called(once);
        verify(documentReference.get()).called(once);
      },
    );

    test(
      ".validateMetricsProjectId() checks if a project with the given metrics project id exists",
      () async {
        whenMetricsProjectExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(document.exists).called(once);
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with a metrics project id validation target if a project with the given metrics project id does not exist",
      () async {
        whenMetricsProjectExists().thenReturn(false);

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.metricsProjectId),
        );
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with an invalid config field validation conclusion if a project with the given metrics project id does not exist",
      () async {
        whenMetricsProjectExists().thenReturn(false);

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.invalid));
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with the 'project does not exist' description if a project with the given metrics project id does not exist",
      () async {
        whenMetricsProjectExists().thenReturn(false);

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        expect(
          result.description,
          equals(FirestoreStrings.metricsProjectIdDoesNotExist),
        );
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with a metrics project id validation target if a Firestore throws a Firestore exception when reading a document",
      () async {
        whenGetMetricsProject().thenAnswer(
          (_) => Future.error(projectInvalidFirestoreException),
        );

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.metricsProjectId),
        );
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with an unknown config field validation conclusion if a Firestore throws a Firestore exception when reading a document",
      () async {
        whenGetMetricsProject().thenAnswer(
          (_) => Future.error(projectInvalidFirestoreException),
        );

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.unknown));
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with the 'metrics project id validation failed' message with the exception code and message if a Firestore throws a Firestore exception when reading a document",
      () async {
        const code = FirestoreExceptionCode.aborted;
        final exception = createFirestoreException(
          code: code,
          message: message,
        );
        final expectedMessage =
            FirestoreStrings.metricsProjectIdValidationFailed(
          '$code',
          message,
        );
        whenGetMetricsProject().thenAnswer((_) => Future.error(exception));

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        expect(result.description, equals(expectedMessage));
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with a metrics project id validation target if the Firebase auth throws during signing in",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.metricsProjectId),
        );
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with an unknown config field validation conclusion if the Firebase auth throws during signing in",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.unknown));
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with the 'unknown error when signing in' description if the Firebase auth throws during signing in",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        expect(
          result.description,
          equals(FirestoreStrings.unknownErrorWhenSigningIn),
        );
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with a metrics project id validation target if the given metrics project id is valid",
      () async {
        whenMetricsProjectExists().thenReturn(true);

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );
        final target = result.target;

        expect(
          target,
          equals(FirestoreDestinationValidationTarget.metricsProjectId),
        );
      },
    );

    test(
      ".validateMetricsProjectId() returns a target validation result with a valid config field validation conclusion if the given metrics project id is valid",
      () async {
        whenMetricsProjectExists().thenReturn(true);

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );
        final conclusion = result.conclusion;

        expect(conclusion, equals(ConfigFieldValidationConclusion.valid));
      },
    );
  });
}

class _FirebaseAuthFactoryMock extends Mock implements FirebaseAuthFactory {}

class _FirestoreFactoryMock extends Mock implements FirestoreFactory {}
