<div align="center" id="top"> 
  <img src="https://d2u2qhufg0q9tn.cloudfront.net/assets/arquivos/imgBannerSeoProd_bannerSeoProd_73a01614-32cc-476e-b80c-7dd9d7ef8bae_Sem_titulo2_Prancheta_1.png" height=100 alt="Elgin_payment_tech" />

&#xa0;

</div>

<h1 align="center">Elgin Payment Tech</h1>

<p align="center">
  <a href="#dart-about">Sobre</a> &#xa0; | &#xa0; 
  <a href="#sparkles-features">Funcionalidades</a> &#xa0; | &#xa0;
  <a href="#rocket-technologies">Tecnologias</a> &#xa0; | &#xa0;
  <a href="#white_check_mark-requirements">Requisitos</a> &#xa0; | &#xa0;
  <a href="#checkered_flag-starting">Start</a> &#xa0; | &#xa0;
  <a href="https://github.com/JY-Labtech" target="_blank">Autor</a>
</p>

<br>

[![Github Badge](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white&link=https://github.com/jhonathanqz)](https://github.com/jhonathanqz)

> ⚠️ Plugin não oficial!

## :dart: Sobre

Plugin Flutter para facilitar integração com o TEF da `Elgin`.
Necessário ter instalado o `Elgin IDH` para que funcione corretamente.

## 🔐 Licenciamento

O plugin exige uma licença válida da JY Labtech. A licença é validada no Android, **sempre no servidor oficial da JY Labtech** (`https://licence-server.invalid/pos-payments/licence/check`), antes de **cada** operação (débito, crédito, crédito parcelado, pix, cancelamento, reimpressão, relatório, ativação/configuração do pinpad, venda e personalização visual). Se a licença for inválida, vencida, suspensa ou cancelada, a operação é bloqueada e o SDK da Elgin não é chamado.

### Onde adquirir

Adquira e gerencie suas licenças no portal **[JY Labtech](https://portal.jylabtech.com.br)**.

- Quem já tinha conta no portal antigo entra com o **mesmo e-mail e senha**.
- As **chaves de licença existentes continuam valendo** (mesmos valores). Chaves novas no formato `JYL-...` também funcionam.
- A licença é do produto **"Licença plugin de pagamento"** e vale para qualquer plugin de pagamento da JY Labtech.
- Planos:
  - `mensal`: cobrado **por dispositivo**;
  - `debug`: até **2 aparelhos** por **365 dias**, concedido automaticamente como cortesia no cadastro (ideal para desenvolvimento).
- Cada aparelho que valida a licença ocupa uma vaga. Aparelhos podem ser desativados no portal (um aparelho desativado deixa de validar).

### Configuração (a partir da versão 2.0.0)

A licença **não é mais passada no código Dart**. Adicione as chaves no arquivo `android/local.properties` do **seu aplicativo**:

```properties
licenceKey=<sua_licenca>
```

- `licenceKey` (**obrigatório**): a chave da sua licença, copiada do portal.
- `licenceInternalKey` (**opcional**, a partir da 2.1.0): endereço do servidor de licenças, em base64 ou texto. Pode ser omitido. Só é aceito se apontar para `https://licence-server.invalid/pos-payments/licence/check...`; qualquer outro valor (inclusive o antigo `***REMOVIDO***...`, outro domínio ou `http://`) é **ignorado** e o servidor oficial é usado.

Também é possível usar as variáveis de ambiente `LICENCE_KEY` e `LICENCE_INTERNAL_KEY` (útil em CI); elas têm prioridade sobre o `local.properties`. Se o `licenceKey` não for encontrado, o build do Android falha com `LicenceKey não encontrado!!`.

### Cache offline

Após uma validação bem-sucedida, a licença é guardada no aparelho de forma criptografada e usada sem internet até o vencimento (`expiredAt`), por no máximo **7 dias** sem uma nova consulta ao servidor. Depois disso o aparelho precisa estar online para validar novamente. O cache é descartado se a licença estiver vencida/inativa/cancelada, se o relógio do aparelho estiver antes da data em que o cache foi salvo (mais de 5 minutos) ou se o `licenceKey` mudar. Caches gravados por versões anteriores com o `licenceInternalKey` antigo (Cloud Run) são descartados uma vez e revalidados online no servidor oficial. A consulta ao servidor tem timeout de 15 s e roda fora da thread principal.

### Erros de licença

Quando a licença é recusada, a chamada ao plugin falha com `PlatformException(code: 'LICENCE_ERROR')`, cuja `message` é a mensagem retornada pelo servidor (ou `Erro ao validar licença (HTTP <código>)`). Os métodos de `payment` lançam essa exceção; os métodos de `style` retornam `false`.

```dart
try {
  final response = await ElginPaymentTech.I.payment.creditTransaction(value: '1000');
} on PlatformException catch (e) {
  if (e.code == 'LICENCE_ERROR') {
    // licença inválida, vencida, suspensa ou cancelada: e.message
  }
}
```

| HTTP | Motivo |
|---|---|
| 404 | Licença não encontrada (chave errada). |
| 412 | Limite de aparelhos da licença atingido ou aparelho desativado no portal. |
| 428 | Licença vencida, suspensa ou cancelada. |
| 403 | Chave de licença não enviada (`licenceKey` vazio). |
| 400 | Não foi possível identificar o aparelho (sem identificador estável). |
| 429 | Muitas consultas em pouco tempo; aguarde e tente novamente. |

Uma resposta 200 com licença vencida, inativa ou cancelada também é recusada.

### Troubleshooting

- **"Licença não encontrada"**: confira o `licenceKey` no `local.properties` (sem espaços/aspas) e faça um build limpo (`flutter clean`), pois as chaves são gravadas no build.
- **Limite de aparelhos**: libere ou desative aparelhos antigos no portal, ou adquira mais dispositivos no plano mensal.
- **Licença vencida/suspensa**: verifique o pagamento/assinatura no portal.
- **Funciona offline e depois para**: o cache local dura no máximo 7 dias; conecte o aparelho à internet para revalidar.
- **Erro de conexão**: o aparelho precisa acessar `https://licence-server.invalid` na primeira validação e a cada 7 dias.

## :sparkles: Funcionalidades

:heavy_check_mark: Cartão de crédito
:heavy_check_mark: Cartão de crédito parcelado
:heavy_check_mark: Cartão de débito
:heavy_check_mark: PIX
:heavy_check_mark: Cancelamento
:heavy_check_mark: Relatório
:heavy_check_mark: Reimpressão

## :rocket: Tecnologias

Para que o plugin funcione corretamente é necessário ter o aplicativo `Elgin IDH` instalado na máquina. Este é fornecido pela própria `Elgin`.

- [Flutter](https://docs.flutter.dev/)
- [Elgin IDH](https://elgindevelopercommunity.github.io/group__idh20.html)

## :white_check_mark: Requisitos

Para que o plugin funcione corretamente é necessário ter o aplicativo `Elgin IDH` instalado na máquina.

## :checkered_flag: Starting

Adicione a dependência no `pubspec.yaml`:

```yaml
dependencies:
  elgin_payment_tech: ^2.1.0
```

Configure a licença no `android/local.properties` (veja [Licenciamento](#-licenciamento)) e inicialize o plugin:

```dart
ElginPaymentTech.I.initPayment();

// Opcional: personalização visual
ElginPaymentTech.I.initStyle();
```

Para utilizar o plugin, basta chamar alguma de suas funções abaixo:

Débito

```dart
ElginPaymentTech.I.payment.debitTransaction(value: value);
```

Crédito:

```dart
ElginPaymentTech.I.payment.creditTransaction(value: value);
```

Crédito Parcelado:

```dart
ElginPaymentTech.I.payment.creditParcTransaction(value: value, parc: parc, financ: financ);
```

Pix:

```dart
ElginPaymentTech.I.payment.pixTransaction(value: value);
```

Cancelar:

```dart
ElginPaymentTech.I.payment.refoundTransaction(value: value, nsu: nsu, date: date);
```

Relatório:

```dart
ElginPaymentTech.I.payment.report(nsu: nsu, date: date);
```

Reimprimir:

```dart
ElginPaymentTech.I.payment.reprinterLastTransaction();
```

#### Todas as transações iram retornar suas informações na classe `ElginResponse`.

### Uma operação por vez

O Elgin IDH processa **uma operação por vez**. Aguarde o `Future` de uma operação antes de iniciar outra:

- Uma nova chamada enquanto outra ainda aguarda resposta (inclusive durante a validação de licença) falha com `PlatformException(code: 'ELGIN_BUSY')`, sem afetar a operação em andamento. Os métodos de `style` retornam `false`.
- Cada chamada recebe sempre a sua própria resposta, uma única vez.
- Transação que volta do IDH sem resposta (ex.: cancelada pelo operador) falha com `PlatformException(code: 'ELGIN_ERROR')` (antes da 2.1.0 o `Future` nunca completava).
- `style.configureBackground` retorna `true` assim que o IDH é aberto (o IDH não devolve resultado para essa tela).

```dart
try {
  final response = await ElginPaymentTech.I.payment.debitTransaction(value: '1000');
} on PlatformException catch (e) {
  switch (e.code) {
    case 'ELGIN_BUSY': // outra operação em andamento: aguarde e tente de novo
    case 'ELGIN_ERROR': // cancelada/sem resposta do IDH ou erro nativo: e.message
    case 'LICENCE_ERROR': // licença recusada: e.message
  }
}
```

## Example

O app de exemplo fica em `example/` (Gradle declarativo: Gradle 8.14.3, AGP 8.13, Kotlin 2.2.20; Flutter 3.47). O build do plugin exige o `licenceKey`, informado de uma destas formas:

- no `example/android/local.properties`:

  ```properties
  licenceKey=<sua_licenca>
  ```

- ou pela variável de ambiente `LICENCE_KEY` (tem prioridade sobre o `local.properties`).

```bash
cd example
LICENCE_KEY=<sua_licenca> flutter run        # ou: flutter build apk --debug
```

Para apenas compilar, qualquer valor serve (ex.: `LICENCE_KEY=JYL-TEST-0000-0000`); para executar operações no aparelho é preciso uma licença válida.

## Testes

```bash
# Testes Dart (MethodChannel mockado)
flutter test

# Testes JVM do nativo Android (licença e operação única), pelo projeto Android do example
cd example/android
LICENCE_KEY=JYL-TEST-0000-0000 ./gradlew :elgin_payment_tech:testDebugUnitTest --no-daemon -Dorg.gradle.jvmargs=-Xmx2g
```

Os testes nativos exigem JDK 17 e que o `flutter pub get` (ou um build) do example já tenha sido executado.

</br>

<table>
  <tr>
    <td align="center"><a href="https://github.com/JY-Labtech"><img src="https://avatars.githubusercontent.com/u/185066406?s=200&v=4" width="100px;" alt=""/><br /><sub><b>JY Labtech</b></sub></a><br /> <a href="https://github.com/JY-Labtech" title="Autor"></a></td>
  </tr>

</table>

&#xa0;

<a href="#top">Back to top</a>
