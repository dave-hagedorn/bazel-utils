load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def github_archive(org, repo, version, override_name = None, sha256 = "", non_bazel = False):
    """Workspace macro that wraps http_archive to make fetching github repos a bit less tedious

    Handles stripping the prefix folder Github adds to downlaoded archives, and how Github strips the "v" from
    archives referenced from tags such as v1.2.3

    Args:
        org:            Github org owning "repo".
        repo:           The Github repo itself - www.github.com/org_name/repo_name.
                        Also used as the archive's name, unless override_name is set.
        version:        The version of the repo to fetch:  commit sha, tag, or branch.
                        If the version is a tag starting with "v", such as v1.2.3
                        this is automatically handled when stripping the prefix folder
                        Github places the downloaded files into - Github does not include the "v"
                        in the prefix folder's name.
        override_name:  The archive's name will normally be the value of repo.
                        Use this to give it a different name.
                        Useful if this is a Bazel repo that requires this archvie to have a
                        specific name.
        sha256:         Same as in http_archive.
        non_bazel:      Set this to true if this archive does not contain a Bazerl workspace and hence needs
                        an external workspace file.
                        In this case, sets build_file to //external_workspaces/repo_name|override_name.build.bazel
                        You will need to create this build file.
    """
    name = override_name or repo
    prefix_version = version[1:] if version.startswith("v") else version
    http_archive(
        name = name,
        sha256 = sha256,
        strip_prefix = "{repo}-{version}".format(repo = repo, version = prefix_version),
        url = "https://www.github.com/{org}/{repo}/archive/{version}.zip".format(org = org, repo = repo, version = version),
        build_file = "@//external_workspaces:{}.build".format(name) if non_bazel else None,
    )

def cc_workspace_dependencies():
    """Workspace macro to do the same things that every (one of my) Bazel C++ workspace(s) needs

    Since Bazel can't run load statements in a macro (https://github.com/bazelbuild/bazel/issues/1550)
    The caller still has to load the rules/macros in these archives (see README.md)

    # End common post-setup

    This macro may be expanded in the future to run other steps common to all (of my) Bazel C++ workspaces
    """

    github_archive(
        org = "hedronvision",
        repo = "bazel-compile-commands-extractor",
        version = "670e86177b6b5c001b03f4efdfba0f8019ff523f",
        override_name = "hedron_compile_commands",
        sha256 = "9e75a976ed9d2485c3c2fa6faf46737297b42a6f2e685c25445f06c3c9482474",
    )

    github_archive(
        org = "grailbio",
        override_name = "com_grail_bazel_toolchain",
        repo = "bazel-toolchain",
        sha256 = "1c813e5ede66901f6ab431f28640aba1590bca28ba9e8dc97661593b41d5dcdf",
        version = "0.7.2",
    )
