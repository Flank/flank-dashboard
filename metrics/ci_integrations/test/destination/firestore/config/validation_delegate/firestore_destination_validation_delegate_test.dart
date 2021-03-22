// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/mappers/firestore_exception_reason_mapper.dart';
import 'package:ci_integration/client/firestore/models/firebase_auth_credentials.dart';
import 'package:ci_integration/destination/firestore/config/validation_delegate/firestore_destination_validation_delegate.dart';
import 'package:ci_integration/destination/firestore/factory/firebase_auth_factory.dart';
import 'package:ci_integration/destination/firestore/factory/firestore_factory.dart';
import 'package:ci_integration/destination/firestore/strings/firestore_strings.dart';
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

    PostExpectation<CollectionReference> whenReferenceCollection({
      String withName,
    }) {
      whenCreateFirestore().thenReturn(firestore);

      return when(firestore.collection(withName));
    }

    PostExpectation<Future<List<Document>>> whenReadDocuments() {
      whenReferenceCollection(
        withName: projectsCollectionName,
      ).thenReturn(collection);

      return when(collection.getDocuments());
    }

    PostExpectation<DocumentReference> whenReferenceDocument({
      String withName,
    }) {
      whenReferenceCollection(
        withName: projectsCollectionName,
      ).thenReturn(collection);

      return when(collection.document(withName));
    }

    PostExpectation<Future<Document>> whenGetDocument() {
      whenReferenceCollection(
        withName: projectsCollectionName,
      ).thenReturn(collection);
      whenReferenceDocument(
        withName: metricsProjectId,
      ).thenReturn(documentReference);

      return when(documentReference.get());
    }

    PostExpectation<bool> whenCheckDocumentExists() {
      whenGetDocument().thenAnswer((_) => Future.value(document));

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
      "throws an ArgumentError if the given firestore factory is null",
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
      ".validatePublicApiKey() returns a failure field validation result if the auth throws a firebase auth exception with the 'invalid api key' code",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validatePublicApiKey(apiKey);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validatePublicApiKey() returns a result with the 'api key invalid' additional context if the auth throws a firebase auth exception with the 'invalid api key' code",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validatePublicApiKey(apiKey);

        expect(
          result.additionalContext,
          equals(FirestoreStrings.apiKeyInvalid),
        );
      },
    );

    test(
      ".validatePublicApiKey() returns a successful field validation result if the auth throws a firebase auth exception with the code does not indicate that the api key is invalid",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer((_) => Future.error(emailNotFoundAuthException));

        final result = await delegate.validatePublicApiKey(apiKey);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validatePublicApiKey() returns a successful field validation result if the sign-in process finishes successfully",
      () async {
        whenSignIn(
          withEmail: '',
          withPassword: '',
        ).thenAnswer((_) => Future.value(user));

        final result = await delegate.validatePublicApiKey(apiKey);

        expect(result.isSuccess, isTrue);
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
      ".validateAuth() returns a failure field validation result if the auth throws a firebase auth exception with the 'email not found' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result containing the exception message if the auth throws a firebase auth exception with the 'email not found' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(emailNotFoundAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(message));
      },
    );

    test(
      ".validateAuth() returns a failure field validation result if the auth throws a firebase auth exception with the 'invalid password' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidPasswordAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result containing the exception message if the auth throws a firebase auth exception with the 'invalid password' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidPasswordAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(message));
      },
    );

    test(
      ".validateAuth() returns a failure field validation result if the auth throws a firebase auth exception with the 'password login disabled' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(passwordLoginDisabledAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result containing the exception message if the auth throws a firebase auth exception with the 'password login disabled' code",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(passwordLoginDisabledAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(message));
      },
    );

    test(
      ".validateAuth() returns a failure field validation result if the auth throws a firebase auth exception with the 'user disabled' code",
      () async {
        whenSignIn().thenAnswer((_) => Future.error(userDisabledAuthException));

        final result = await delegate.validateAuth(credentials);

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result containing the exception message if the auth throws a firebase auth exception with the 'user disabled' code",
      () async {
        whenSignIn().thenAnswer((_) => Future.error(userDisabledAuthException));

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(message));
      },
    );

    test(
      ".validateAuth() returns an unknown field validation result if the auth throws a firebase auth exception with the code does not indicate that the auth is invalid",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.isUnknown, isTrue);
      },
    );

    test(
      ".validateAuth() returns a field validation result with the 'auth validation failed' additional context containing the exception code and message if the auth throws a firebase auth exception with the code does not indicate that the auth is invalid",
      () async {
        whenSignIn().thenAnswer(
          (_) => Future.error(invalidApiKeyAuthException),
        );
        final expectedAdditionalContext =
            FirestoreStrings.authValidationFailedMessage(
          '${invalidApiKeyAuthException.code}',
          invalidApiKeyAuthException.message,
        );

        final result = await delegate.validateAuth(credentials);

        expect(result.additionalContext, equals(expectedAdditionalContext));
      },
    );

    test(
      ".validateAuth() returns a successful field validation result if the sign-in process finishes successfully",
      () async {
        whenSignIn().thenAnswer((_) => Future.value(user));

        final result = await delegate.validateAuth(credentials);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateFirebaseProjectId() creates a firebase auth using the firebase auth factory",
      () async {
        whenReadDocuments().thenAnswer((_) => Future.value([]));

        await delegate.validateFirebaseProjectId(credentials, projectId);

        verify(authFactory.create(apiKey)).called(1);
      },
    );

    test(
      ".validateFirebaseProjectId() signs in using the firebase auth and the given credentials",
      () async {
        final expectedEmail = credentials.email;
        final expectedPassword = credentials.password;
        whenReadDocuments().thenAnswer((_) => Future.value([]));

        await delegate.validateFirebaseProjectId(credentials, projectId);

        verify(firebaseAuth.signIn(expectedEmail, expectedPassword)).called(1);
      },
    );

    test(
      ".validateFirebaseProjectId() creates a firestore instance using the firestore factory",
      () async {
        whenReadDocuments().thenAnswer((_) => Future.value([]));

        await delegate.validateFirebaseProjectId(credentials, projectId);

        verify(firestoreFactory.create(projectId, firebaseAuth)).called(1);
      },
    );

    test(
      ".validateFirebaseProjectId() reads documents from the 'projects' collection",
      () async {
        whenReadDocuments().thenAnswer((_) => Future.value([]));

        await delegate.validateFirebaseProjectId(credentials, projectId);

        verify(firestore.collection(projectsCollectionName)).called(1);
        verify(collection.getDocuments()).called(1);
      },
    );

    test(
      ".validateFirebaseProjectId() returns a failure field validation result if the firestore throws a firestore exception with the 'consumer invalid' exception reason",
      () async {
        whenReadDocuments().thenAnswer(
          (_) => Future.error(consumerInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateFirebaseProjectId() returns a field validation result with the 'invalid firebase project id' additional context if the firestore throws a firestore exception with the 'consumer invalid' exception reason",
      () async {
        whenReadDocuments().thenAnswer(
          (_) => Future.error(consumerInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(
          result.additionalContext,
          equals(FirestoreStrings.projectIdInvalid),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a failure field validation result if the firestore throws a firestore exception with the 'not found' exception reason",
      () async {
        whenReadDocuments().thenAnswer(
          (_) => Future.error(notFoundFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateFirebaseProjectId() returns a field validation result with the 'invalid firebase project id' additional context if the firestore throws a firestore exception with the 'not found' exception reason",
      () async {
        whenReadDocuments().thenAnswer(
          (_) => Future.error(notFoundFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(
          result.additionalContext,
          equals(FirestoreStrings.projectIdInvalid),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a failure field validation result if the firestore throws a firestore exception with the 'project deleted' exception reason",
      () async {
        whenReadDocuments().thenAnswer(
          (_) => Future.error(projectDeletedFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateFirebaseProjectId() returns a field validation result with the 'invalid firebase project id' additional context if the firestore throws a firestore exception with the 'project deleted' exception reason",
      () async {
        whenReadDocuments().thenAnswer(
          (_) => Future.error(projectDeletedFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(
          result.additionalContext,
          equals(FirestoreStrings.projectIdInvalid),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a failure field validation result if the firestore throws a firestore exception with the 'project invalid' exception reason",
      () async {
        whenReadDocuments().thenAnswer(
          (_) => Future.error(projectInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateFirebaseProjectId() returns a field validation result with the 'invalid firebase project id' additional context if the firestore throws a firestore exception with the 'project invalid' exception reason",
      () async {
        whenReadDocuments().thenAnswer(
          (_) => Future.error(projectInvalidFirestoreException),
        );

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(
          result.additionalContext,
          equals(FirestoreStrings.projectIdInvalid),
        );
      },
    );

    test(
      ".validateFirebaseProjectId() returns a success field validation result if the firestore throws a firestore exception with empty exception reasons",
      () async {
        final exception = createFirestoreException(reasons: []);
        whenReadDocuments().thenAnswer((_) => Future.error(exception));

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateFirebaseProjectId() returns a success field validation result if the firestore throws a firestore exception with null exception reasons",
      () async {
        final exception = createFirestoreException(reasons: null);
        whenReadDocuments().thenAnswer((_) => Future.error(exception));

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateFirebaseProjectId() returns a success field validation result if reading documents process succeeds",
      () async {
        whenReadDocuments().thenAnswer((_) => Future.value([]));

        final result = await delegate.validateFirebaseProjectId(
          credentials,
          projectId,
        );

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      ".validateMetricsProjectId() creates a firebase auth using the firebase auth factory",
      () async {
        whenCheckDocumentExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(authFactory.create(apiKey)).called(1);
      },
    );

    test(
      ".validateMetricsProjectId() signs in using the firebase auth and the given credentials",
      () async {
        final expectedEmail = credentials.email;
        final expectedPassword = credentials.password;
        whenCheckDocumentExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(firebaseAuth.signIn(expectedEmail, expectedPassword)).called(1);
      },
    );

    test(
      ".validateMetricsProjectId() creates a firestore instance using the firestore factory",
      () async {
        whenCheckDocumentExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(firestoreFactory.create(projectId, firebaseAuth)).called(1);
      },
    );

    test(
      ".validateMetricsProjectId() reads a document from the projects collection with the given metrics project id",
      () async {
        whenCheckDocumentExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(firestore.collection('projects')).called(1);
        verify(collection.document(metricsProjectId)).called(1);
        verify(documentReference.get()).called(1);
      },
    );

    test(
      ".validateMetricsProjectId() checks if a project with the given metrics project id exists",
      () async {
        whenCheckDocumentExists().thenReturn(true);

        await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        verify(document.exists).called(1);
      },
    );

    test(
      ".validateMetricsProjectId() returns a failure field validation result if a project with the given metrics project id does not exist",
      () async {
        whenCheckDocumentExists().thenReturn(false);

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        expect(result.isFailure, isTrue);
      },
    );

    test(
      ".validateMetricsProjectId() returns a field validation result with the 'project does not exist' additional context if a project with the given metrics project id does not exist",
      () async {
        whenCheckDocumentExists().thenReturn(false);

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        expect(
          result.additionalContext,
          equals(FirestoreStrings.metricsProjectIdDoesNotExist),
        );
      },
    );

    test(
      ".validateMetricsProjectId() returns an unknown field validation result if a firestore throws a firestore exception when reading a document",
      () async {
        whenGetDocument().thenAnswer(
          (_) => Future.error(projectInvalidFirestoreException),
        );

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        expect(result.isUnknown, isTrue);
      },
    );

    test(
      ".validateMetricsProjectId() returns a field validation result with the 'metrics project id validation failed' message with the exception code and message if a firestore throws a firestore exception when reading a document",
      () async {
        const code = FirestoreExceptionCode.aborted;
        final exception = createFirestoreException(
          code: code,
          message: message,
        );
        final expectedMessage =
            FirestoreStrings.metricsProjectIdValidationFailedMessage(
          '$code',
          message,
        );
        whenGetDocument().thenAnswer((_) => Future.error(exception));

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        expect(result.additionalContext, equals(expectedMessage));
      },
    );

    test(
      ".validateMetricsProjectId() returns a success field validation result if the given metrics project id is valid",
      () async {
        whenCheckDocumentExists().thenReturn(true);

        final result = await delegate.validateMetricsProjectId(
          credentials,
          projectId,
          metricsProjectId,
        );

        expect(result.isSuccess, isTrue);
      },
    );
  });
}

class _FirebaseAuthFactoryMock extends Mock implements FirebaseAuthFactory {}

class _FirestoreFactoryMock extends Mock implements FirestoreFactory {}
