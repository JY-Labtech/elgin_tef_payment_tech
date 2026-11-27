# Elgin Payment Tech

> **English:** Open source (MIT) Flutter plugin for Elgin TEF payments on Android through the Elgin IDH (E1 Digital Hub) app: credit (single and installments), debit, PIX, refund, reprint, report, pinpad setup and IDH visual customization.

[![pub package](https://img.shields.io/pub/v/elgin_payment_tech.svg)](https://pub.dev/packages/elgin_payment_tech)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Plugin Flutter para integrar seu app ao **TEF da Elgin** no Android. O plugin abre o aplicativo **Elgin IDH** (E1 Digital Hub) por `Intent`, envia a operação (venda, cancelamento, reimpressão etc.) e devolve a resposta do IDH ao Dart como `ElginResponse`.

- Open source, licença **MIT**. Sem licença paga, sem chave e sem chamadas a servidores da JY Labtech.
- Plugin **não oficial**: não é mantido pela Elgin.

## Sumário

1. [Funcionalidades](#funcionalidades)
2. [Compatibilidade e requisitos](#compatibilidade-e-requisitos)
3. [Instalação](#instalação)
4. [Configuração Android](#configuração-android)
5. [Uso rápido](#uso-rápido)
6. [Referência da API](#referência-da-api)
7. [Exemplos por operação](#exemplos-por-operação)
8. [Tratamento de erros](#tratamento-de-erros)
9. [App de exemplo](#app-de-exemplo)
10. [Testes](#testes)
11. [Migração da 2.x para a 3.0.0](#migração-da-2x-para-a-300)
12. [Contribuindo](#contribuindo)
13. [Licença](#licença)
14. [Créditos](#créditos)

## Funcionalidades

Pagamentos (`ElginPaymentTech.I.payment`):

- Crédito à vista (`creditTransaction`)
- Crédito parcelado, com financiamento pelo estabelecimento ou pela administradora (`creditParcTransaction`)
- Débito (`debitTransaction`)
- PIX (`pixTransaction`)
- Cancelamento/estorno (`refoundTransaction`)
- Reimpressão do último comprovante (`reprinterLastTransaction`)
- Relatório (`report`)
- Menu de venda do IDH (`sale`)
- Ativação do terminal com CNPJ/CPF (`activeTerminal`)
- Configuração do pinpad: nome e versão do app e texto do visor (`configurePinpad`)

Personalização visual do IDH (`ElginPaymentTech.I.style`):

- Fundo: logotipo, cor sólida ou gradiente (`configureBackground`)
- Cabeçalho: cores de botão, ícone e fonte (`configureCustomHeader`)
- Área central: cores de botão, ícone, fonte e mensagem (`configureIconsCenter`)
- Restaurar o visual padrão (`clearAllStyle`)

Também:

- Uma operação por vez, com resposta única por chamada (`ELGIN_BUSY` para chamadas concorrentes).
- Modelos tipados da resposta: `ElginResponse` e `ElginTransactionResponse`.

## Compatibilidade e requisitos

| Item | Requisito |
|---|---|
| Plataforma | Somente **Android** (o iOS não é suportado) |
| Android | `minSdk` 23 (Android 6.0); o plugin compila com `compileSdk` 36 |
| Flutter / Dart | Flutter ≥ 3.0.0, Dart ≥ 3.0.0 (testado no Flutter 3.47) |
| Java | O plugin compila com Java 11; o app de exemplo usa JDK 17 |
| App do fabricante | **Elgin IDH** (E1 Digital Hub) instalado e configurado no aparelho, que responde às ações `com.elgin.e1.digitalhub.TEF` e `com.elgin.e1.digitalhub.CUSTOM` |
| Hardware | Terminais/PDVs Android compatíveis com o TEF Elgin (pinpad USB, `tipoPinpad = ANDROID_USB` em crédito e débito) |

Documentação do IDH: <https://elgindevelopercommunity.github.io/group__idh20.html>.

### Permissões e features

O `AndroidManifest.xml` do plugin é mesclado ao do seu app e declara:

- Permissões: `USB_PERMISSION`, `NFC`, `BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `BLUETOOTH` e `BLUETOOTH_ADMIN` (até o API 30), `WRITE_EXTERNAL_STORAGE` e `MANAGE_EXTERNAL_STORAGE`.
- Features: `android.hardware.usb.host` (**obrigatória**), `android.hardware.nfc` e `android.hardware.bluetooth_le` (opcional).

Como `usb.host` é obrigatória, lojas de apps só instalam o app em aparelhos com USB host. Se precisar mudar isso, sobrescreva no manifest do seu app com `tools:replace` ou `tools:node`.

## Instalação

```bash
flutter pub add elgin_payment_tech
```

Ou no `pubspec.yaml`:

```yaml
dependencies:
  elgin_payment_tech: ^3.0.0
```

## Configuração Android

Não há chave, credencial nem repositório Maven extra: o plugin não usa SDK binário, só `Intent` para o Elgin IDH, e as dependências vêm do `google()` e do `mavenCentral()`.

1. **`minSdk` ≥ 23** no `android/app/build.gradle` do seu app:

   ```groovy
   android {
       defaultConfig {
           minSdk = 23 // ou flutter.minSdkVersion, se for >= 23
       }
   }
   ```

2. **AndroidX e Jetifier** no `android/gradle.properties` (o plugin usa bibliotecas que ainda precisam do Jetifier):

   ```properties
   android.useAndroidX=true
   android.enableJetifier=true
   org.gradle.jvmargs=-Xmx2g
   ```

   Com o Jetifier ligado, o Gradle precisa de pelo menos 2 GB de heap; com menos, o build pode falhar com `Java heap space`.

3. **Activity**: use a `FlutterActivity` (ou `FlutterFragmentActivity`) padrão. O plugin recebe a resposta do IDH por `onActivityResult`, então não é preciso nenhum `intent-filter` no seu app.

4. **Android 11+ (visibilidade de pacotes)**: o IDH é aberto por `Intent` implícita. Se o seu `targetSdk` for 30 ou maior e o IDH não abrir, declare as ações no manifest do seu app:

   ```xml
   <manifest ...>
       <queries>
           <intent>
               <action android:name="com.elgin.e1.digitalhub.TEF" />
           </intent>
           <intent>
               <action android:name="com.elgin.e1.digitalhub.CUSTOM" />
           </intent>
       </queries>
   </manifest>
   ```

## Uso rápido

```dart
import 'package:elgin_payment_tech/elgin_payment_tech.dart';
import 'package:flutter/services.dart';

Future<void> vender() async {
  // Uma vez, ao abrir a tela/app.
  final payment = ElginPaymentTech.I.initPayment();

  try {
    final ElginResponse? response = await payment.creditTransaction(value: '1000');

    if (response != null && response.isTransactionValid) {
      final tx = response.transaction!;
      print('Aprovada. NSU: ${tx.nsu}, autorização: ${tx.autorizacao}');
      print(tx.viaCliente); // comprovante do cliente
    } else {
      print('Não aprovada: ${response?.mensagem}');
    }
  } on PlatformException catch (e) {
    // ELGIN_BUSY: outra operação em andamento. ELGIN_ERROR: cancelada, sem resposta ou erro nativo.
    print('${e.code}: ${e.message}');
  }
}
```

O formato do `value` é repassado sem alteração ao IDH (extra `valor`). Use o formato que o seu IDH/adquirente espera; os exemplos deste README usam centavos como texto (`'1000'` = R$ 10,00).

## Referência da API

### `ElginPaymentTech`

Singleton de entrada: `ElginPaymentTech.I`.

| Membro | Retorno | Descrição |
|---|---|---|
| `initPayment()` | `Payment` | Cria (uma vez) e devolve a instância de pagamentos. Pode ser chamado várias vezes. |
| `initStyle()` | `ElginStyle` | Cria (uma vez) e devolve a instância de personalização visual. |
| `payment` | `Payment` | Instância criada por `initPayment()`. Lança `Exception` se `initPayment()` não foi chamado. |
| `style` | `ElginStyle` | Instância criada por `initStyle()`. Lança `Exception` se `initStyle()` não foi chamado. |

```dart
ElginPaymentTech.I.initPayment();
ElginPaymentTech.I.initStyle(); // opcional

await ElginPaymentTech.I.payment.debitTransaction(value: '1000');
await ElginPaymentTech.I.style.clearAllStyle();
```

### `Payment`

Todos os métodos abrem o Elgin IDH e devolvem `Future<ElginResponse?>` com a resposta do IDH. Em erro, lançam `PlatformException` (veja [Tratamento de erros](#tratamento-de-erros)).

| Método | Parâmetros | Operação no IDH (`funcao`) |
|---|---|---|
| `creditTransaction({required String value})` | `value`: valor | `credito`, 1 parcela |
| `creditParcTransaction({required String value, required String parc, required String financ})` | `parc`: número de parcelas; `financ`: tipo de financiamento (veja abaixo) | `credito` parcelado |
| `debitTransaction({required String value})` | `value`: valor | `debito` |
| `pixTransaction({required String value})` | `value`: valor | `pix` |
| `refoundTransaction({required String value, required String nsu, required String date})` | `value`: valor da venda; `nsu`: NSU SiTef da venda; `date`: data da venda | `cancelar` (modalidade 200) |
| `reprinterLastTransaction()` | nenhum | `reimprimir` |
| `report({required String nsu, required String date})` | `nsu`, `date`: enviados ao canal, mas **não** repassados ao IDH, porque a documentação da Elgin define o `relatorio` só com o extra `funcao` (pode passar `''`) | `relatorio` |
| `sale()` | nenhum | `vender` (menu de venda do IDH) |
| `activeTerminal({required String companyDocument})` | `companyDocument`: CNPJ/CPF do estabelecimento | `ativar` |
| `configurePinpad({required String appName, required String version, required String textPinpad})` | nome e versão do seu app e texto exibido no pinpad | `configurar` |

O `financ` é repassado ao extra `financiamento` do IDH. A enum `PaymentTypeCredit` (em `package:elgin_payment_tech/payments/utils/payment_types.dart`) tem os valores usados pelo TEF: `SALESMAN` (2, parcelado pelo estabelecimento) e `CLIENT` (3, parcelado pela administradora). Ex.: `financ: '${PaymentTypeCredit.SALESMAN.value}'`.

```dart
final payment = ElginPaymentTech.I.payment;
final response = await payment.pixTransaction(value: '2500');
```

### `ElginStyle`

Personaliza o visual do IDH. Os parâmetros são cores em hexadecimal (ex.: `'#1E88E5'`) e um caminho de imagem para o logotipo. Todos os métodos retornam `Future<bool>`: `true` quando o IDH foi aberto/respondeu, `false` em qualquer erro do nativo (inclusive `ELGIN_BUSY`).

| Método | Parâmetros (todos opcionais) | Regras |
|---|---|---|
| `configureBackground({String? logoPath, String? backgroundColorHex, String? gradientStartHex, String? gradientEndHex})` | logotipo, cor de fundo, início e fim do gradiente | Pelo menos um parâmetro; `gradientStartHex` e `gradientEndHex` andam juntos. Retorna `true` assim que o IDH abre (essa tela não devolve resultado). |
| `configureCustomHeader({String? buttonColorHex, String? iconColorHex, String? fontColorHex})` | cores do cabeçalho | Pelo menos um parâmetro. |
| `configureIconsCenter({String? buttonColorHex, String? iconColorHex, String? fontColorHex, String? fontMessageColorHex})` | cores da área central | Pelo menos um parâmetro. |
| `clearAllStyle()` | nenhum | Volta ao visual padrão. |

Se as regras não forem respeitadas, o método lança `Exception` antes de chamar o nativo.

```dart
final style = ElginPaymentTech.I.initStyle();
await style.configureBackground(gradientStartHex: '#0D47A1', gradientEndHex: '#42A5F5');
await style.configureCustomHeader(buttonColorHex: '#FFFFFF', fontColorHex: '#0D47A1');
```

### `ElginResponse`

Resposta do IDH (JSON) já convertida.

| Campo | Tipo | Descrição |
|---|---|---|
| `funcao` | `String?` | Operação executada (ex.: `credito`, `debito`, `pix`, `cancelar`). |
| `mensagem` | `String?` | Mensagem do IDH (ex.: `Transacao aprovada`). |
| `transaction` | `ElginTransactionResponse?` | Dados da transação (campo `resultado` do IDH), quando houver. |
| `resultCode` | `int?` | Chave `resultCode` do JSON, quando presente (aceita número ou texto numérico). A documentação do IDH não define essa chave na resposta TEF; o status da Activity (`RESULT_OK`/`RESULT_CANCELED`) não é repassado. |
| `isTransactionValid` | `bool` | `true` quando há `transaction` com `nsu` preenchido. |

Também tem `fromJson`, `fromMap`, `toJson`, `toMap` e `copyWith`.

### `ElginTransactionResponse`

Campos (`String?`): `administradora`, `autorizacao`, `cnpjRede`, `data`, `mensagem`, `nsu`, `numeroCartao`, `pagamento`, `rede`, `tipoCartao`, `valor`, `vencimento`, `viaCliente`, `viaEstabelecimento`, `viaSMS`. `isTransactionValid` é `true` quando `nsu` não é vazio.

### Enums

Em `package:elgin_payment_tech/payments/utils/payment_types.dart`:

- `PaymentTypeCall`: métodos do canal (`CREDIT`, `CREDIT_PARC`, `DEBIT`, `PIX`, `REFOUND`, `REPRINTER`, `REPORT`, `ACTIVE_TERMINAL`, `CONFIGURE_PINPAD`, `SALE`); `.method` dá o nome usado no MethodChannel. Uso interno.
- `PaymentTypeTransaction`: `CREDIT` (1), `DEBIT` (2), `PIX` (3), `CREDIT_PARC` (4), via `.type`.
- `PaymentTypeCredit`: `SALESMAN` (2) e `CLIENT` (3), via `.value`, para o `financ` do crédito parcelado.

## Exemplos por operação

Todos supõem `final payment = ElginPaymentTech.I.initPayment();`.

### Crédito à vista

```dart
final r = await payment.creditTransaction(value: '1000');
```

### Crédito parcelado

```dart
import 'package:elgin_payment_tech/payments/utils/payment_types.dart';

final r = await payment.creditParcTransaction(
  value: '30000',
  parc: '3',
  financ: '${PaymentTypeCredit.SALESMAN.value}', // parcelado pelo estabelecimento
);
```

### Débito

```dart
final r = await payment.debitTransaction(value: '1000');
```

### PIX

```dart
final r = await payment.pixTransaction(value: '1000');
```

### Cancelamento / estorno

Use o NSU e a data da venda original (da `ElginTransactionResponse` da venda):

```dart
final venda = await payment.creditTransaction(value: '1000');
final tx = venda!.transaction!;

final cancelamento = await payment.refoundTransaction(
  value: '1000',
  nsu: tx.nsu!,
  date: tx.data!, // no formato que o IDH devolveu na venda
);
```

### Reimpressão

```dart
await payment.reprinterLastTransaction();
```

### Relatório

```dart
await payment.report(nsu: '', date: '');
```

### Menu de venda do IDH

```dart
await payment.sale();
```

### Ativação do terminal e configuração do pinpad

```dart
await payment.activeTerminal(companyDocument: '12345678000199');
await payment.configurePinpad(appName: 'Meu PDV', version: '1.0.0', textPinpad: 'MEU PDV');
```

### Personalização visual

```dart
final style = ElginPaymentTech.I.initStyle();
await style.configureBackground(logoPath: '/sdcard/Download/logo.png', backgroundColorHex: '#FFFFFF');
await style.configureIconsCenter(buttonColorHex: '#0D47A1', fontMessageColorHex: '#212121');
await style.clearAllStyle();
```

## Tratamento de erros

Os métodos de `payment` lançam `PlatformException`. Os de `style` retornam `false` nos mesmos casos.

| Código | Quando acontece |
|---|---|
| `ELGIN_BUSY` | Já existe uma operação aguardando resposta do IDH. A operação em andamento não é afetada; aguarde o `Future` dela e tente de novo. |
| `ELGIN_ERROR` | O IDH voltou sem resposta (ex.: operação cancelada pelo operador), a Activity/engine foi encerrada antes da resposta, o plugin não estava anexado a uma Activity, ou houve erro ao abrir o IDH (ex.: IDH não instalado). A `message` traz o detalhe. |

Além disso:

- `MissingPluginException`: o plugin não está registrado (ex.: rodando fora do Android).
- `Exception` em `ElginPaymentTech.I.payment`/`style`: `initPayment()`/`initStyle()` não foi chamado.
- `Exception` nos métodos de `style`: parâmetros inválidos (nenhum informado, ou gradiente incompleto).
- `FormatException`: o IDH devolveu algo que não é JSON.

```dart
try {
  final r = await ElginPaymentTech.I.payment.debitTransaction(value: '1000');
} on PlatformException catch (e) {
  switch (e.code) {
    case 'ELGIN_BUSY':
      // outra operação em andamento
      break;
    case 'ELGIN_ERROR':
      // cancelada/sem resposta do IDH ou erro nativo: e.message
      break;
  }
}
```

### Uma operação por vez

O Elgin IDH processa uma operação por vez. O plugin guarda o `Result` de cada chamada e responde exatamente uma vez, sempre na chamada certa. Uma segunda chamada enquanto a primeira está pendente falha com `ELGIN_BUSY`. Respostas repetidas ou atrasadas do IDH são descartadas.

## App de exemplo

O app fica em `example/` (Gradle declarativo: Gradle 8.14.3, AGP 8.13, Kotlin 2.2.20). Não precisa de chave nem de configuração extra:

```bash
cd example
flutter run            # ou: flutter build apk --debug
```

Para operar de verdade, rode num terminal Elgin com o IDH instalado. O example de debug é assinado com a keystore em `example/Chaves`, que não vai para o pub.dev: num clone sem essa pasta, remova o `signingConfig` do `example/android/app/build.gradle`. Se o build falhar com `Java heap space`, rode o Gradle com `-Dorg.gradle.jvmargs=-Xmx2g` (ex.: `cd example/android && ./gradlew :app:assembleDebug -Dorg.gradle.jvmargs=-Xmx2g`).

## Testes

```bash
# Testes Dart (MethodChannel mockado): todos os métodos de payment e style
flutter test

# Testes JVM do nativo Android (operação única, resposta única e abertura do IDH por método),
# pelo projeto Android do example (JDK 17; rode `flutter pub get` no example antes)
cd example/android
./gradlew :elgin_payment_tech:testDebugUnitTest --no-daemon -Dorg.gradle.jvmargs=-Xmx2g
```

## Migração da 2.x para a 3.0.0

A 3.0.0 remove toda a licença paga. A API Dart de pagamentos e de estilo não muda.

O que mudou:

- O build não lê mais `licenceKey`/`licenceInternalKey` (`local.properties`) nem `LICENCE_KEY`/`LICENCE_INTERNAL_KEY` (ambiente). Apague essas chaves; o erro `LicenceKey não encontrado!!` não existe mais.
- O código `LICENCE_ERROR` não existe mais. Remova esse `case` do seu tratamento de erros.
- A constante `licenceCheck` e o import `package:elgin_payment_tech/licence/constants/licence_constants.dart` foram removidos.
- O plugin não acessa mais a internet nem guarda cache de licença no aparelho.
- A permissão `READ_PHONE_STATE` saiu do manifest do plugin (só servia à licença). Se o seu app precisar dela, declare no manifest do app.
- `ElginResponse.resultCode` agora é lido da chave `resultCode` (antes lia `resultado` e podia lançar `TypeError`).

Antes (2.x):

```properties
# android/local.properties
licenceKey=SUA-LICENCA
licenceInternalKey=aHR0cHM6Ly9...
```

```dart
import 'package:elgin_payment_tech/licence/constants/licence_constants.dart';

try {
  await ElginPaymentTech.I.payment.creditTransaction(value: '1000');
} on PlatformException catch (e) {
  if (e.code == 'LICENCE_ERROR') { /* licença recusada */ }
  if (e.code == 'ELGIN_BUSY') { /* ... */ }
}
```

Depois (3.0.0):

```properties
# android/local.properties: nada do plugin
```

```dart
try {
  await ElginPaymentTech.I.payment.creditTransaction(value: '1000');
} on PlatformException catch (e) {
  if (e.code == 'ELGIN_BUSY') { /* ... */ }
  if (e.code == 'ELGIN_ERROR') { /* ... */ }
}
```

## Contribuindo

Issues e pull requests são bem-vindos em <https://github.com/JY-Labtech/elgin_tef_payment_tech>.

1. Abra uma issue descrevendo o bug ou a proposta (modelo do terminal, versão do IDH e logs ajudam).
2. Faça um fork, crie um branch e inclua testes (`flutter test` e os testes JVM acima).
3. Rode `flutter analyze` antes de abrir o PR.

## Licença

Distribuído sob a licença [MIT](LICENSE).

## Créditos

Desenvolvido e mantido pela **JY Labtech**: <https://jylabtech.com.br> · [GitHub](https://github.com/JY-Labtech).

Elgin, Elgin IDH e E1 Digital Hub são marcas dos seus respectivos donos. Este projeto não é afiliado à Elgin.
