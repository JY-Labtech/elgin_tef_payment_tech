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

## :dart: Sobre

Plugin Flutter para facilitar integração com o TEF da `Elgin`.
Necessário ter instalado o `Elgin IDH` para que funcione corretamente.

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

Para liberar o plugin para uso, execute a função abaixo passando como parâmetro o licenceKey fornecido:

```dart
ElginPaymentTech.instance.initPayment({required String licenceKey})

ElginPaymentTech.instance.initStyle({required String licenceKey})
```

Para adquirir uma licença entre no site da <a href="https://licenca.jylabtech.com.br" target="_blank">JY Labtech</a>
<br>

Para utilizar o plugin, basta chamar alguma de suas funções abaixo:

Débito

```dart
ElginPaymentTech.instance().payment.debitTransaction(value: value);
```

Crédito:

```dart
ElginPaymentTech.instance().payment.creditTransaction(value: value);
```

Crédito Parcelado:

```dart
ElginPaymentTech.instance().payment.creditParcTransaction(value: value, parc: parc, financ: financ);
```

Pix:

```dart
ElginPaymentTech.instance().payment.pixTransaction(value: value);
```

Cancelar:

```dart
ElginPaymentTech.instance().payment.refoundTransaction(value: value, nsu: nsu, date: date);
```

Relatório:

```dart
ElginPaymentTech.instance().payment.report(nsu: nsu, date: date);
```

Reimprimir:

```dart
ElginPaymentTech.instance().payment.reprinterLastTransaction();
```

#### Todas as transações iram retornar suas informações na classe `ElginResponse`.

## :memo: License

This project is under license from MIT. For more details, see the [LICENSE](LICENSE.md) file.

</br>

<table>
  <tr>
    <td align="center"><a href="https://github.com/JY-Labtech"><img src="https://avatars.githubusercontent.com/u/185066406?s=200&v=4" width="100px;" alt=""/><br /><sub><b>JY Labtech</b></sub></a><br /> <a href="https://github.com/JY-Labtech" title="Autor"></a></td>
  </tr>

</table>

&#xa0;

<a href="#top">Back to top</a>
