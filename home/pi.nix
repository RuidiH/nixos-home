{ lib, stdenvNoCC, fetchurl, nodejs, makeWrapper, cacert }:

let
  version = "0.78.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
    hash = "sha256-oEfadYAdkTXjaKRxHQbQyktqtwiAGrgv0TZt3h7t0O4=";
  };

  deps = stdenvNoCC.mkDerivation {
    pname = "pi-coding-agent-deps";
    inherit version src;

    nativeBuildInputs = [ nodejs cacert ];

    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      cd $out
      export HOME=$(mktemp -d)
      npm install --omit=dev --omit=optional --ignore-scripts --no-audit --no-fund
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-d+FjNQIzxJx/QdemfKpPzRo6INMKEPWh0ONQ7XEgK60=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "pi-coding-agent";
  inherit version;

  src = deps;

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/pi-coding-agent $out/bin
    cp -r . $out/lib/pi-coding-agent/
    chmod +x $out/lib/pi-coding-agent/dist/cli.js
    makeWrapper ${nodejs}/bin/node $out/bin/pi \
      --add-flags "$out/lib/pi-coding-agent/dist/cli.js"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Minimal terminal coding agent (npm: @earendil-works/pi-coding-agent)";
    homepage = "https://github.com/earendil-works/pi";
    license = licenses.mit;
    mainProgram = "pi";
    platforms = platforms.unix;
  };
}
