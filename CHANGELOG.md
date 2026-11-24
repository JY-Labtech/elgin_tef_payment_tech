## 2.2.0

- Licença conforme o contrato do jylabtech_core (JYN-234): o cache offline vale por no máximo 72 horas (antes 7 dias) e só é usado quando o servidor não responde (sem internet, timeout, 5xx).
- A primeira operação depois de abrir o app consulta o servidor, e a licença é revalidada a cada 4 horas de uso; o atalho só-cache (`validateExistsLicence`) só libera quando nenhuma consulta online está pendente.
- Recusa do servidor (cliente bloqueado, licença vencida/cancelada/suspensa, não encontrada, aparelho desativado) apaga o cache e bloqueia na hora.

## 2.1.0

- **Validação de licença mais rígida (Android):**
  - A URL de validação é travada no servidor oficial da JY Labtech (`https://licence-server.invalid/pos-payments/licence/check`). O `licenceInternalKey` agora é **opcional** e qualquer valor fora do servidor oficial (inclusive a URL antiga do Cloud Run, outros domínios ou `http://`) é ignorado. O build não falha mais sem `licenceInternalKey`.
  - Toda operação (pagamentos, cancelamento, reimpressão, relatório, ativação/configuração do pinpad, venda e personalização visual) valida a licença antes de chamar o SDK. Licença inválida, vencida, suspensa ou cancelada responde `PlatformException(code: 'LICENCE_ERROR')` com a mensagem do servidor (antes chegava como texto e causava `FormatException` no Dart, e o nativo relançava `RuntimeException`).
  - Resposta 200 com licença vencida, inativa, cancelada (`isCanceled`) ou sem `expiredAt` é recusada e não é salva em cache.
  - Cache offline só vale se a licença for utilizável, tiver no máximo 7 dias, não estiver datado no futuro (relógio adulterado, tolerância de 5 min) e pertencer à mesma chave; caso contrário é apagado e a licença é revalidada online. Caches salvos com o `licenceInternalKey` antigo (Cloud Run) ou qualquer valor fora do servidor oficial são descartados e revalidados no core; o cache novo guarda a URL oficial efetiva.
  - Consulta ao servidor com timeout de 15 s e fora da main thread (não trava mais a UI do POS).
  - Erros nativos que não são de licença respondem `PlatformException(code: 'ELGIN_ERROR')` em vez de derrubar o app.
  - Removido import do embedding v1 (`PluginRegistry.Registrar`), que não compila mais no Flutter atual; `namespace` definido no `build.gradle` do plugin.
- Constante `licenceCheck` aponta para o endpoint completo do core.
- Testes: JVM (JUnit) para URL, regras de licença, cache, respostas HTTP e fluxo de validação, e testes Dart do MethodChannel (`LICENCE_ERROR`).
- Validação de licença migrada para o novo servidor da JY Labtech (`https://licence-server.invalid/pos-payments/licence/check`). O contrato é o mesmo e as chaves de licença existentes continuam valendo.
- `licenceInternalKey` no `local.properties` passa a ser opcional (veja o README).
- Licenças agora são adquiridas e gerenciadas no portal https://portal.jylabtech.com.br (substitui `licenca.jylabtech.com.br`).
- Android: mensagem de erro de licença mais clara quando o servidor não retorna `message` (ex.: HTTP 429) e licença vencida/inativa retornada pelo servidor não é mais aceita.
- README: seção de licença reescrita (planos, limite por aparelho, cache offline, tabela de erros e troubleshooting) e exemplos de uso corrigidos (`ElginPaymentTech.I.initPayment()`).
- **Uma operação por vez (Android):** o `Result` de cada chamada não é mais guardado em um campo estático compartilhado (que podia ser sobrescrito por uma segunda chamada, fazendo a resposta ir para a chamada errada ou ser enviada duas vezes). Agora cada resposta vai sempre para a sua própria chamada e é enviada uma única vez.
  - Uma nova operação enquanto outra aguarda resposta do Elgin IDH (inclusive durante a validação de licença) falha com `PlatformException(code: 'ELGIN_BUSY')`; a operação em andamento não é afetada. Os métodos de `style` retornam `false` nesse caso.
  - Transação TEF que volta do IDH sem resposta (ex.: cancelada) agora completa com `PlatformException(code: 'ELGIN_ERROR')`; antes o `Future` nunca completava.
  - `configureBackground` agora completa (`true`) ao abrir o IDH; antes o `Future` nunca completava, porque o IDH é aberto sem retorno de resultado.
  - Se a Activity/engine for encerrada com uma operação pendente, ela completa com `ELGIN_ERROR`. Após mudança de configuração (ex.: rotação) as próximas operações usam a Activity nova.
- Example migrado para o Gradle declarativo (bloco `plugins {}`): Gradle 8.14.3, AGP 8.13 e Kotlin 2.2.20, compatível com o Flutter 3.47.
- `compileSdk` do plugin 31 → 36 (as dependências AndroidX atuais exigem `compileSdk` ≥ 33).
- README: como rodar o example (`LICENCE_KEY`) e os testes nativos pelo example.
- Testes JUnit da fila de operação única (`ELGIN_BUSY`, resposta única) e teste Dart de `ELGIN_BUSY`.

## 🔥 2.0.0+1 – Breaking Change

⚠️ Attention: In this version, there is an important change in the way payments are initialized.

🛠️ What changed:

Breaking Change: The initPayment method no longer requires the licenceKey to be passed as a parameter.

It is now mandatory to define the following fields in local.properties:

licenceKey → main licence key

licenceInternalKey → internal licence key

This means that any code that previously passed licenceKey directly to initPayment will need to be updated.

## 1.1.1

- Corrige bug ao validar licença
- ~~Adiciona método para limpar cache de licença~~ (nota corrigida: esse método nunca foi exposto na API pública do plugin. O cache de licença é gerenciado automaticamente: é descartado ao trocar o `licenceKey`, ao vencer ou após 7 dias sem revalidação — veja "Cache offline" no README.)

## 1.1.0

- Corrige bug ao validar licença

## 1.0.6

- Primeiro release do Plugin.
- Funções: cŕedito, crédito parcelado, débito, pix, voucher, ativar terminal.
- Update dart sdk

## 1.0.5

- Primeiro release do Plugin.
- Funções: cŕedito, crédito parcelado, débito, pix, voucher, ativar terminal.
- Update dart sdk

## 1.0.1

- Primeiro release do Plugin.
- Funções: cŕedito, crédito parcelado, débito, pix, voucher, ativar terminal.

## 1.0.0

- Primeiro release do Plugin.
- Funções: cŕedito, crédito parcelado, débito, pix, voucher, ativar terminal.
