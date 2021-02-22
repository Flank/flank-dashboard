// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/mappers/github_token_scope_mapper.dart';
import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:test/test.dart';

void main() {
  group("GithubTokenScopeMapper", () {
    const mapper = GithubTokenScopeMapper();

    test(
      ".map() maps the repo scope to the GithubTokenScope.repo",
      () {
        const expectedScope = GithubTokenScope.repo;

        final scope = mapper.map(GithubTokenScopeMapper.repo);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the repo status scope to the GithubTokenScope.repoStatus",
      () {
        const expectedScope = GithubTokenScope.repoStatus;

        final scope = mapper.map(GithubTokenScopeMapper.repoStatus);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the repo deployment scope to the GithubTokenScope.repoDeployment",
      () {
        const expectedScope = GithubTokenScope.repoDeployment;

        final scope = mapper.map(GithubTokenScopeMapper.repoDeployment);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the repo public scope to the GithubTokenScope.repoPublic",
      () {
        const expectedScope = GithubTokenScope.repoPublic;

        final scope = mapper.map(GithubTokenScopeMapper.repoPublic);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the repo invite scope to the GithubTokenScope.repoInvite",
      () {
        const expectedScope = GithubTokenScope.repoInvite;

        final scope = mapper.map(GithubTokenScopeMapper.repoInvite);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the security events scope to the GithubTokenScope.securityEvents",
      () {
        const expectedScope = GithubTokenScope.securityEvents;

        final scope = mapper.map(GithubTokenScopeMapper.securityEvents);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the admin repo hook scope to the GithubTokenScope.adminRepoHook",
      () {
        const expectedScope = GithubTokenScope.adminRepoHook;

        final scope = mapper.map(GithubTokenScopeMapper.adminRepoHook);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write repo hook scope to the GithubTokenScope.writeRepoHook",
      () {
        const expectedScope = GithubTokenScope.writeRepoHook;

        final scope = mapper.map(GithubTokenScopeMapper.writeRepoHook);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read repo hook scope to the GithubTokenScope.readRepoHook",
      () {
        const expectedScope = GithubTokenScope.readRepoHook;

        final scope = mapper.map(GithubTokenScopeMapper.readRepoHook);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the admin org scope to the GithubTokenScope.adminOrg",
      () {
        const expectedScope = GithubTokenScope.adminOrg;

        final scope = mapper.map(GithubTokenScopeMapper.adminOrg);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write org scope to the GithubTokenScope.writeOrg",
      () {
        const expectedScope = GithubTokenScope.writeOrg;

        final scope = mapper.map(GithubTokenScopeMapper.writeOrg);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read org scope to the GithubTokenScope.readOrg",
      () {
        const expectedScope = GithubTokenScope.readOrg;

        final scope = mapper.map(GithubTokenScopeMapper.readOrg);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the admin public key scope to the GithubTokenScope.adminPublicKey",
      () {
        const expectedScope = GithubTokenScope.adminPublicKey;

        final scope = mapper.map(GithubTokenScopeMapper.adminPublicKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write public key scope to the GithubTokenScope.writePublicKey",
      () {
        const expectedScope = GithubTokenScope.writePublicKey;

        final scope = mapper.map(GithubTokenScopeMapper.writePublicKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read public key scope to the GithubTokenScope.readPublicKey",
      () {
        const expectedScope = GithubTokenScope.readPublicKey;

        final scope = mapper.map(GithubTokenScopeMapper.readPublicKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the admin org hook scope to the GithubTokenScope.adminOrgHook",
      () {
        const expectedScope = GithubTokenScope.adminOrgHook;

        final scope = mapper.map(GithubTokenScopeMapper.adminOrgHook);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the gist scope to the GithubTokenScope.gist",
      () {
        const expectedScope = GithubTokenScope.gist;

        final scope = mapper.map(GithubTokenScopeMapper.gist);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the notifications scope to the GithubTokenScope.notifications",
      () {
        const expectedScope = GithubTokenScope.notifications;

        final scope = mapper.map(GithubTokenScopeMapper.notifications);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the user scope to the GithubTokenScope.user",
      () {
        const expectedScope = GithubTokenScope.user;

        final scope = mapper.map(GithubTokenScopeMapper.user);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read user scope to the GithubTokenScope.readUser",
      () {
        const expectedScope = GithubTokenScope.readUser;

        final scope = mapper.map(GithubTokenScopeMapper.readUser);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the user email scope to the GithubTokenScope.userEmail",
      () {
        const expectedScope = GithubTokenScope.userEmail;

        final scope = mapper.map(GithubTokenScopeMapper.userEmail);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the user follow scope to the GithubTokenScope.userFollow",
      () {
        const expectedScope = GithubTokenScope.userFollow;

        final scope = mapper.map(GithubTokenScopeMapper.userFollow);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the delete repo scope to the GithubTokenScope.deleteRepo",
      () {
        const expectedScope = GithubTokenScope.deleteRepo;

        final scope = mapper.map(GithubTokenScopeMapper.deleteRepo);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write discussion scope to the GithubTokenScope.writeDiscussion",
      () {
        const expectedScope = GithubTokenScope.writeDiscussion;

        final scope = mapper.map(GithubTokenScopeMapper.writeDiscussion);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read discussion scope to the GithubTokenScope.readDiscussion",
      () {
        const expectedScope = GithubTokenScope.readDiscussion;

        final scope = mapper.map(GithubTokenScopeMapper.readDiscussion);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write packages scope to the GithubTokenScope.writePackages",
      () {
        const expectedScope = GithubTokenScope.writePackages;

        final scope = mapper.map(GithubTokenScopeMapper.writePackages);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read packages scope to the GithubTokenScope.readPackages",
      () {
        const expectedScope = GithubTokenScope.readPackages;

        final scope = mapper.map(GithubTokenScopeMapper.readPackages);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the delete packages scope to the GithubTokenScope.deletePackages",
      () {
        const expectedScope = GithubTokenScope.deletePackages;

        final scope = mapper.map(GithubTokenScopeMapper.deletePackages);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the admin GPG key scope to the GithubTokenScope.adminGPGKey",
      () {
        const expectedScope = GithubTokenScope.adminGPGKey;

        final scope = mapper.map(GithubTokenScopeMapper.adminGPGKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the write GPG key scope to the GithubTokenScope.writeGPGKey",
      () {
        const expectedScope = GithubTokenScope.writeGPGKey;

        final scope = mapper.map(GithubTokenScopeMapper.writeGPGKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read GPG key scope to the GithubTokenScope.readGPGKey",
      () {
        const expectedScope = GithubTokenScope.readGPGKey;

        final scope = mapper.map(GithubTokenScopeMapper.readGPGKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the workflow scope to the GithubTokenScope.workflow",
      () {
        const expectedScope = GithubTokenScope.workflow;

        final scope = mapper.map(GithubTokenScopeMapper.workflow);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the admin enterprise scope to the GithubTokenScope.adminEnterprise",
      () {
        const expectedScope = GithubTokenScope.adminEnterprise;

        final scope = mapper.map(GithubTokenScopeMapper.adminEnterprise);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the manage billing enterprise scope to the GithubTokenScope.manageBillingEnterprise",
      () {
        const expectedScope = GithubTokenScope.manageBillingEnterprise;

        final scope = mapper.map(
          GithubTokenScopeMapper.manageBillingEnterprise,
        );

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".map() maps the read enterprise scope to the GithubTokenScope.readEnterprise",
      () {
        const expectedScope = GithubTokenScope.readEnterprise;

        final scope = mapper.map(GithubTokenScopeMapper.readEnterprise);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.repo to the repo scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.repo;

        final scope = mapper.unmap(GithubTokenScope.repo);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.repoStatus to the repo status scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.repoStatus;

        final scope = mapper.unmap(GithubTokenScope.repoStatus);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.repoDeployment to the repo deployment scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.repoDeployment;

        final scope = mapper.unmap(GithubTokenScope.repoDeployment);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.repoPublic to the repo public scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.repoPublic;

        final scope = mapper.unmap(GithubTokenScope.repoPublic);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.repoInvite to the repo invite scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.repoInvite;

        final scope = mapper.unmap(GithubTokenScope.repoInvite);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.securityEvents to the security events scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.securityEvents;

        final scope = mapper.unmap(GithubTokenScope.securityEvents);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.adminRepoHook to the admin repo hook scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.adminRepoHook;

        final scope = mapper.unmap(GithubTokenScope.adminRepoHook);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.writeRepoHook to the write repo hook scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.writeRepoHook;

        final scope = mapper.unmap(GithubTokenScope.writeRepoHook);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.readRepoHook to the read repo hook scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.readRepoHook;

        final scope = mapper.unmap(GithubTokenScope.readRepoHook);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.adminOrg to the admin org scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.adminOrg;

        final scope = mapper.unmap(GithubTokenScope.adminOrg);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.writeOrg to the write org scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.writeOrg;

        final scope = mapper.unmap(GithubTokenScope.writeOrg);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.readOrg to the read org scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.readOrg;

        final scope = mapper.unmap(GithubTokenScope.readOrg);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.adminPublicKey to the admin public key scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.adminPublicKey;

        final scope = mapper.unmap(GithubTokenScope.adminPublicKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.writePublicKey to the write public key scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.writePublicKey;

        final scope = mapper.unmap(GithubTokenScope.writePublicKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.readPublicKey to the read public key scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.readPublicKey;

        final scope = mapper.unmap(GithubTokenScope.readPublicKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.adminOrgHook to the admin org hook scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.adminOrgHook;

        final scope = mapper.unmap(GithubTokenScope.adminOrgHook);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.gist to the gist scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.gist;

        final scope = mapper.unmap(GithubTokenScope.gist);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.notifications to the notifications scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.notifications;

        final scope = mapper.unmap(GithubTokenScope.notifications);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.user to the user scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.user;

        final scope = mapper.unmap(GithubTokenScope.user);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.readUser to the read user scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.readUser;

        final scope = mapper.unmap(GithubTokenScope.readUser);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.userEmail to the user email scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.userEmail;

        final scope = mapper.unmap(GithubTokenScope.userEmail);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.userFollow to the user follow scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.userFollow;

        final scope = mapper.unmap(GithubTokenScope.userFollow);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.deleteRepo to the delete repo scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.deleteRepo;

        final scope = mapper.unmap(GithubTokenScope.deleteRepo);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.writeDiscussion to the write discussion scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.writeDiscussion;

        final scope = mapper.unmap(GithubTokenScope.writeDiscussion);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.readDiscussion to the read discussion scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.readDiscussion;

        final scope = mapper.unmap(GithubTokenScope.readDiscussion);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.writePackages to the write packages scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.writePackages;

        final scope = mapper.unmap(GithubTokenScope.writePackages);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.readPackages to the read packages scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.readPackages;

        final scope = mapper.unmap(GithubTokenScope.readPackages);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.deletePackages to the delete packages scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.deletePackages;

        final scope = mapper.unmap(GithubTokenScope.deletePackages);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.adminGPGKey to the admin GPG key scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.adminGPGKey;

        final scope = mapper.unmap(GithubTokenScope.adminGPGKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.writeGPGKey to the write GPG key scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.writeGPGKey;

        final scope = mapper.unmap(GithubTokenScope.writeGPGKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.readGPGKey to the read GPG key scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.readGPGKey;

        final scope = mapper.unmap(GithubTokenScope.readGPGKey);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.workflow to the workflow scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.workflow;

        final scope = mapper.unmap(GithubTokenScope.workflow);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.adminEnterprise to the admin enterprise scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.workflow;

        final scope = mapper.unmap(GithubTokenScope.workflow);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.manageBillingEnterprise to the manage billing enterprise scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.manageBillingEnterprise;

        final scope = mapper.unmap(GithubTokenScope.manageBillingEnterprise);

        expect(scope, equals(expectedScope));
      },
    );

    test(
      ".unmap() unmaps the GithubTokenScope.readEnterprise to the read enterprise scope value",
      () {
        const expectedScope = GithubTokenScopeMapper.readEnterprise;

        final scope = mapper.unmap(GithubTokenScope.readEnterprise);

        expect(scope, equals(expectedScope));
      },
    );
  });
}
