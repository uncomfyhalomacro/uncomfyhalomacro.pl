+++
title = "Exploring Efficient Ways To Package Rust Software in openSUSE"
authors = ["Soc Virnyl Estela"]
description = "a small short guide on how to setup VSCodium Flatpak on an immutable desktop"
date = 2024-08-22
draft = false
[taxonomies]
  tags = ["packaging", "rust", "opensuse"]
+++


> **Update**
> I am moving over some logic as another package called [roast](https://github.com/openSUSE-Rust/roast). This is to prepare this vendoring alternative called [obs-service-cargo-vendor-home-registry](https://github.com/openSUSE-Rust/obs-service-cargo-vendor-home-registry). The project is still worked on during my free time.

I have re-investigated possible solutions for confusing packaging in [[Tech/Compilers and Languages/Rust|Rust]]. Currently, we are using `cargo vendor` to vendor package dependencies. This comes at a cost.
- Back and forth copying of `.cargo/config.toml` for possible projects that use monorepo configurations i.e. workspace and real monorepos.
	- Examples of these are: zellij, wezterm and python-tokenizers
- We always want to ensure `Cargo.lock` and I doubt the solution will not avoid this since lockfiles are always essential when building software with Rust.
- Existing `.cargo/config.toml` from projects will be overridden with our generated `.cargo/config.toml`.

The first solution I thought of is a global `.cargo/config.toml` for projects. This has been done with **python-tokenizers** in openSUSE because it is possible to use `--manifest-path` to specify a manifest `Cargo.toml` file in the specfile for cargo invocations.

Seeing this, I realised, why not just use the `$CARGO_HOME` since we are pointing at a global cache anyway? This blog is about tracking my future project
<https://github.com/uncomfyhalomacro/obs-service-cargo-vendor-home-registry> of which I plan to integrate into <https://github.com/Firstyear/obs-service-cargo> as an alternative vendor generating utility for Open Build Service or OBS.

# Storage size eaten by `CARGO_HOME` vs `cargo vendor` comparison

> **NOTE**
> `cargo fetch`, `cargo vendor`, `cargo build`, and `cargo generate-lockfile` all update the `CARGO_HOME` or what we call the cargo home registry or just cargo home. We use `cargo fetch` here because it's designed to update the registry cache instead of other commands.
>
> **WARNING** Behaviours between `cargo fetch` and `cargo generate-lockfile`
> `cargo fetch` updates the registry to latest version of crates and also regenerates `Cargo.lock` to reflect the versions unless `--locked` flag is passed where it tries to respect the versions of the crates from the existing `Cargo.lock` despite this *contradicting* description in the manpage that 
> If a Cargo.lock file is available, this command will ensure that all of the git dependencies and/or registry dependencies are downloaded and locally available. Subsequent Cargo commands will be able to run offline after a cargo fetch unless the lock file changes.
>  
>  However, `cargo generate-lockfile` updates the registry + updates the `Cargo.lock` which in my opinion is just a duplication of the other cargo sub-command `cargo update`. Why? Both do the same behaviour. Even the part where you pass `--locked` will give you the same error "**error: the lock file /run/host/tmp/jay-1.4.0/Cargo.lock needs to be updated but --locked**".


Here are the zstd compressed tarballs for the following after running the cargo commands 

**wezterm**
- `cargo-vendor`: 1.1GB
- `cargo-fetch`: 1.3GB

**jay**
- `cargo-vendor`: 24MB
- `cargo-fetch`: 76MB

**zellij**
- `cargo-vendor`: 66MB
- `cargo-fetch`: 133MB

Why does it seem like `cargo-fetch` duplicates the contents in the tarball? Because it really does. The registry contains the following directory structure

```
.
└── registry
    ├── cache
    │   └── index.crates.io-6f17d22bba15001f
    ├── index
    │   └── index.crates.io-6f17d22bba15001f
    └── src
        └── index.crates.io-6f17d22bba15001f

8 directories, 0 files

```

One can remove the `.cargo/registry/src` directory as that contains the extracted crates and then create a `tar.zst` file using the following commands

```bash
# Assuming $CARGO_HOME is set to $PWD/.cargo
pushd .cargo
rm -rfv registry/src
popd
tar --zstd -cvf vendor.tar.zst .cargo/
```
# How to get cache from `$CARGO_HOME`

Any of these commands will generate the cargo home registry cache
- build
- generate-lockfile
- vendor
- fetch
- update

Some commands are duplication of the other commands i.e. update and generate-lockfile. It's just that the former prefetches the latest crate versions while the latter doesn't.

To update the registry cache, one must either go with `cargo fetch` or even `cargo vendor` to avoid building or updating (unless update is set).

### Why not go with `cargo vendor --sync`

Reason? Uncertainty of how that command respect `Cargo.lock` for each crate. I would rather have do
	
```bash
cargo fetch --locked --manifest-path=path/to/Cargo.toml
```

for each manifest found since one can flexibly turn `--locked` on and off.

# Building now with `$CARGO_HOME`

## Path dependencies in `Cargo.toml` needs to be revisited 

## Lockfiles are always inconsistent

See <https://github.com/rust-lang/cargo/issues/7169>. This is a glaring issue and not just for `cargo install` but almost all cargo commands such as `cargo fetch`. That's why in openSUSE, we try to include the lockfile as much as possible even if passing `--locked`. I think I would agree to this comment <https://github.com/rust-lang/cargo/issues/7169#issuecomment-539226733>.

Observation
- `cargo fetch --locked` does not work because it tries to keep the registry cache updated
- `cargo vendor --locked` works because I don't know why???

Now is the use of `--sync` idea thrown out the window?

For crates that don't ship with a lockfile, we will run either`cargo generate-lockfile` or `cargo update`, former is more semantically correct to do as opposed to `cargo update`. But `update` makes sense the most because we are going to add update options on the new project anyway.
