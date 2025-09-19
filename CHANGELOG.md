## 🔥 2.0.0 – Breaking Change

⚠️ Attention: In this version, there is an important change in the way payments are initialized.

🛠️ What changed:

Breaking Change: The initPayment method no longer requires the licenceKey to be passed as a parameter.

It is now mandatory to define the following fields in local.properties:

licenceKey → main licence key

licenceInternalKey → internal licence key

This means that any code that previously passed licenceKey directly to initPayment will need to be updated.

## 1.1.1

- Corrige bug ao validar licença
- Adiciona método para limpar cache de licença

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
