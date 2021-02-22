// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_token_scope.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping Github token scopes.
class GithubTokenScopeMapper implements Mapper<String, GithubTokenScope> {
  /// A token scope that allows to access to private and public repositories.
  static const String repo = 'repo';

  /// A token scope that allows to read and write access
  /// to public and private repository commit statuses.
  static const String repoStatus = 'repo:status';

  /// A token scope that allows accessing deployment statuses
  /// for public and private repositories.
  static const String repoDeployment = 'repo_deployment';

  /// A token scope that allows to read and write access to code, commit statuses,
  /// repository projects, collaborators, and deployment statuses
  /// for public repositories and organizations.
  static const String repoPublic = 'public_repo';

  /// A token scope that allows to accept and decline abilities for invitations
  /// to collaborate on a repository.
  static const String repoInvite = 'repo:invite';

  /// A token scope that allows to read and write security events.
  static const String securityEvents = 'security_events';

  /// A token scope that allows to read, write, ping, and delete access
  /// to repository hooks in public and private repositories.
  static const String adminRepoHook = 'admin:repo_hook';

  /// A token scope that allows to read, write, and ping access to hooks
  /// in public or private repositories.
  static const String writeRepoHook = 'write:repo_hook';

  /// A token scope that allows to read and ping access to hooks
  /// in public or private repositories.
  static const String readRepoHook = 'read:repo_hook';

  /// A token scope that allows to manage the organization and its teams,
  /// projects, and memberships.
  static const String adminOrg = 'admin:org';

  /// A token scope that allows to read and write access to organization membership,
  /// organization projects, and team membership.
  static const String writeOrg = 'write:org';

  /// A token scope that allows to read-only access to organization membership,
  /// organization projects, and team membership.
  static const String readOrg = 'read:org';

  /// A token scope that allows to manage public keys.
  static const String adminPublicKey = 'admin:public_key';

  /// A token scope that allows to create, list, and view details for public keys.
  static const String writePublicKey = 'write:public_key';

  /// A token scope that allows to list and view details for public keys.
  static const String readPublicKey = 'read:public_key';

  /// A token scope that allows to read, write, ping, and delete access
  /// to organization hooks.
  static const String adminOrgHook = 'admin:org_hook';

  /// A token scope that allows to write access to gists.
  static const String gist = 'gist';

  /// A token scope that allows to access notifications.
  static const String notifications = 'notifications';

  /// A token scope that allows to read and write access to profile info only.
  static const String user = 'user';

  /// A token scope that allows to read a user's profile data.
  static const String readUser = 'read:user';

  /// A token scope that allows to read user's email addresses.
  static const String userEmail = 'user:email';

  /// A token scope that allows to follow and unfollow other users.
  static const String userFollow = 'user:follow';

  /// A token scope that allows to delete repositories.
  static const String deleteRepo = 'delete_repo';

  /// A token scope that allows to read and write team discussions.
  static const String writeDiscussion = 'write:discussion';

  /// A token scope that allows to read team discussions.
  static const String readDiscussion = 'read:discussion';

  /// A token scope that allows to upload or publish packages
  /// to GitHub Package Registry.
  static const String writePackages = 'write:packages';

  /// A token scope that allows to download or install packages
  /// from GitHub Package Registry.
  static const String readPackages = 'read:packages';

  /// A token scope that allows to delete packages from GitHub Package Registry.
  static const String deletePackages = 'delete:packages';

  /// A token scope that allows to manage GPG keys.
  static const String adminGPGKey = 'admin:gpg_key';

  /// A token scope that allows to create, list, and view details for GPG keys.
  static const String writeGPGKey = 'write:gpg_key';

  /// A token scope that allows to list and view details for GPG keys.
  static const String readGPGKey = 'read:gpg_key';

  /// A token scope that allows to update GitHub Action workflows.
  static const String workflow = 'workflow';

  /// A token scope that allows to control of enterprises.
  static const String adminEnterprise = 'admin:enterprise';

  /// A token scope that allows to read and write enterprise billing data.
  static const String manageBillingEnterprise = 'manage_billing:enterprise';

  /// A token scope that allows to read enterprise profile data.
  static const String readEnterprise = 'read:enterprise';

  /// Creates a new instance of the [GithubTokenScopeMapper].
  const GithubTokenScopeMapper();

  @override
  GithubTokenScope map(String value) {
    switch (value) {
      case repo:
        return GithubTokenScope.repo;
      case repoStatus:
        return GithubTokenScope.repoStatus;
      case repoDeployment:
        return GithubTokenScope.repoDeployment;
      case repoPublic:
        return GithubTokenScope.repoPublic;
      case repoInvite:
        return GithubTokenScope.repoInvite;
      case securityEvents:
        return GithubTokenScope.securityEvents;
      case adminRepoHook:
        return GithubTokenScope.adminRepoHook;
      case writeRepoHook:
        return GithubTokenScope.writeRepoHook;
      case readRepoHook:
        return GithubTokenScope.readRepoHook;
      case adminOrg:
        return GithubTokenScope.adminOrg;
      case writeOrg:
        return GithubTokenScope.writeOrg;
      case readOrg:
        return GithubTokenScope.readOrg;
      case adminPublicKey:
        return GithubTokenScope.adminPublicKey;
      case writePublicKey:
        return GithubTokenScope.writePublicKey;
      case readPublicKey:
        return GithubTokenScope.readPublicKey;
      case adminOrgHook:
        return GithubTokenScope.adminOrgHook;
      case gist:
        return GithubTokenScope.gist;
      case notifications:
        return GithubTokenScope.notifications;
      case user:
        return GithubTokenScope.user;
      case readUser:
        return GithubTokenScope.readUser;
      case userEmail:
        return GithubTokenScope.userEmail;
      case userFollow:
        return GithubTokenScope.userFollow;
      case deleteRepo:
        return GithubTokenScope.deleteRepo;
      case writeDiscussion:
        return GithubTokenScope.writeDiscussion;
      case readDiscussion:
        return GithubTokenScope.readDiscussion;
      case writePackages:
        return GithubTokenScope.writePackages;
      case readPackages:
        return GithubTokenScope.readPackages;
      case deletePackages:
        return GithubTokenScope.deletePackages;
      case adminGPGKey:
        return GithubTokenScope.adminGPGKey;
      case writeGPGKey:
        return GithubTokenScope.writeGPGKey;
      case readGPGKey:
        return GithubTokenScope.readGPGKey;
      case workflow:
        return GithubTokenScope.workflow;
      case adminEnterprise:
        return GithubTokenScope.adminEnterprise;
      case manageBillingEnterprise:
        return GithubTokenScope.manageBillingEnterprise;
      case readEnterprise:
        return GithubTokenScope.readEnterprise;
      default:
        return null;
    }
  }

  @override
  String unmap(GithubTokenScope value) {
    switch (value) {
      case GithubTokenScope.repo:
        return repo;
      case GithubTokenScope.repoStatus:
        return repoStatus;
      case GithubTokenScope.repoDeployment:
        return repoDeployment;
      case GithubTokenScope.repoPublic:
        return repoPublic;
      case GithubTokenScope.repoInvite:
        return repoInvite;
      case GithubTokenScope.securityEvents:
        return securityEvents;
      case GithubTokenScope.adminRepoHook:
        return adminRepoHook;
      case GithubTokenScope.writeRepoHook:
        return writeRepoHook;
      case GithubTokenScope.readRepoHook:
        return readRepoHook;
      case GithubTokenScope.adminOrg:
        return adminOrg;
      case GithubTokenScope.writeOrg:
        return writeOrg;
      case GithubTokenScope.readOrg:
        return readOrg;
      case GithubTokenScope.adminPublicKey:
        return adminPublicKey;
      case GithubTokenScope.writePublicKey:
        return writePublicKey;
      case GithubTokenScope.readPublicKey:
        return readPublicKey;
      case GithubTokenScope.adminOrgHook:
        return adminOrgHook;
      case GithubTokenScope.gist:
        return gist;
      case GithubTokenScope.notifications:
        return notifications;
      case GithubTokenScope.user:
        return user;
      case GithubTokenScope.readUser:
        return readUser;
      case GithubTokenScope.userEmail:
        return userEmail;
      case GithubTokenScope.userFollow:
        return userFollow;
      case GithubTokenScope.deleteRepo:
        return deleteRepo;
      case GithubTokenScope.writeDiscussion:
        return writeDiscussion;
      case GithubTokenScope.readDiscussion:
        return readDiscussion;
      case GithubTokenScope.writePackages:
        return writePackages;
      case GithubTokenScope.readPackages:
        return readPackages;
      case GithubTokenScope.deletePackages:
        return deletePackages;
      case GithubTokenScope.adminGPGKey:
        return adminGPGKey;
      case GithubTokenScope.writeGPGKey:
        return writeGPGKey;
      case GithubTokenScope.readGPGKey:
        return readGPGKey;
      case GithubTokenScope.workflow:
        return workflow;
      case GithubTokenScope.adminEnterprise:
        return adminEnterprise;
      case GithubTokenScope.manageBillingEnterprise:
        return manageBillingEnterprise;
      case GithubTokenScope.readEnterprise:
        return readEnterprise;
      default:
        return null;
    }
  }
}
