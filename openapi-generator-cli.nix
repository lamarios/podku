# openapi-generator-cli.nix
{ lib, stdenvNoCC, fetchurl, jre, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "openapi-generator-cli";
  version = "7.24.0";

  src = fetchurl {
    url = "https://github.com/OpenAPITools/openapi-generator/releases/download/v${version}/openapi-generator-cli-${version}.jar";
    hash = "sha256-S4PMxv1DBWyMYxzQGV5RAL0FUJElAlJ7qwmsdhUtqww=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp $src $out/share/java/openapi-generator-cli.jar

    makeWrapper ${jre}/bin/java $out/bin/openapi-generator-cli \
      --add-flags "-jar $out/share/java/openapi-generator-cli.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Generate clients, server stubs, docs, and configs from an OpenAPI spec";
    homepage = "https://github.com/OpenAPITools/openapi-generator";
    changelog = "https://github.com/OpenAPITools/openapi-generator/releases/tag/v${version}";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    mainProgram = "openapi-generator-cli";
    platforms = platforms.all;
  };
}