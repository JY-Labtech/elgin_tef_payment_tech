# elgin_payment_tech_example

Demonstra como usar o plugin `elgin_payment_tech`.

## Como rodar

Projeto Android no Gradle declarativo (Gradle 8.14.3, AGP 8.13, Kotlin 2.2.20), compatível com o Flutter 3.47.

O build do plugin exige o `licenceKey` (sem ele falha com `LicenceKey não encontrado!!`). Informe de uma destas formas:

- em `example/android/local.properties`:

  ```properties
  licenceKey=<sua_licenca>
  ```

- ou pela variável de ambiente `LICENCE_KEY` (tem prioridade sobre o `local.properties`).

```bash
cd example
LICENCE_KEY=<sua_licenca> flutter run
# ou apenas compilar:
LICENCE_KEY=JYL-TEST-0000-0000 flutter build apk --debug
```

Para executar operações no aparelho é preciso uma licença válida e o `Elgin IDH` instalado.

## Testes nativos do plugin

```bash
cd example/android
LICENCE_KEY=JYL-TEST-0000-0000 ./gradlew :elgin_payment_tech:testDebugUnitTest --no-daemon -Dorg.gradle.jvmargs=-Xmx2g
```

Requer JDK 17.
