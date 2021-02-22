// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/github_actions/models/github_token.dart';

/// An [Enum] that represents a scope of the [GithubToken].
enum GithubTokenScope {
  /// A token scope that allows to access to private and public repositories.
  repo,

  /// A token scope that allows to read and write access to public and private
  /// repository commit statuses.
  repoStatus,

  /// A token scope that allows accessing deployment statuses for public and
  /// private repositories.
  repoDeployment,

  /// A token scope that allows to read and write access to code, commit statuses,
  /// repository projects, collaborators, and deployment statuses
  /// for public repositories and organizations.
  repoPublic,

  /// A token scope that allows to accept and decline abilities for invitations
  /// to collaborate on a repository.
  repoInvite,

  /// A token scope that allows to read and write security events.
  securityEvents,

  /// A token scope that allows to read, write, ping, and delete access
  /// to repository hooks in public and private repositories.
  adminRepoHook,

  /// A token scope that allows to read, write, and ping access to hooks
  /// in public or private repositories.
  writeRepoHook,

  /// A token scope that allows to read and ping access to hooks in public
  /// or private repositories.
  readRepoHook,

  /// A token scope that allows to manage the organization and its teams,
  /// projects, and memberships.
  adminOrg,

  /// A token scope that allows to read and write access to organization membership,
  /// organization projects, and team membership.
  writeOrg,

  /// A token scope that allows to read-only access to organization membership,
  /// organization projects, and team membership.
  readOrg,

  /// A token scope that allows to manage public keys.
  adminPublicKey,

  /// A token scope that allows to create, list, and view details for public keys.
  writePublicKey,

  /// A token scope that allows to list and view details for public keys.
  readPublicKey,

  /// A token scope that allows to read, write, ping, and delete access
  /// to organization hooks.
  adminOrgHook,

  /// A token scope that allows to write access to gists.
  gist,

  /// A token scope that allows to access notifications.
  notifications,

  /// A token scope that allows to read and write access to profile info only.
  user,

  /// A token scope that allows to read a user's profile data.
  readUser,

  /// A token scope that allows to read user's email addresses.
  userEmail,

  /// A token scope that allows to follow and unfollow other users.
  userFollow,

  /// A token scope that allows to delete repositories.
  deleteRepo,

  /// A token scope that allows to read and write team discussions.
  writeDiscussion,

  /// A token scope that allows to read team discussions.
  readDiscussion,

  /// A token scope that allows to upload or publish packages
  /// to GitHub Package Registry.
  writePackages,

  /// A token scope that allows to download or install packages
  /// from GitHub Package Registry.
  readPackages,

  /// A token scope that allows to delete packages from GitHub Package Registry.
  deletePackages,

  /// A token scope that allows to manage GPG keys.
  adminGPGKey,

  /// A token scope that allows to create, list, and view details for GPG keys.
  writeGPGKey,

  /// A token scope that allows to list and view details for GPG keys.
  readGPGKey,

  /// A token scope that allows to update GitHub Action workflows.
  workflow,

  /// A token scope that allows to control of enterprises.
  adminEnterprise,

  /// A token scope that allows to read and write enterprise billing data.
  manageBillingEnterprise,

  /// A token scope that allows to read enterprise profile data.
  readEnterprise,
}
