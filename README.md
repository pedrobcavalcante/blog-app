# Blog App 🚀

O **Blog App** é uma aplicação criada com **Flutter** para visualização, gerenciamento e interação com posts e comentários. Ele utiliza uma arquitetura limpa, separando lógica de negócios, camada de dados e apresentação, com gerenciamento de estado via **Cubit/Bloc** e navegação modular através do **Flutter Modular**.

---

## Índice

- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Recursos Principais](#recursos-principais)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Configuração do Ambiente](#configuração-do-ambiente)
  - [Pré-requisitos](#pré-requisitos)
  - [Variáveis Sensíveis](#variáveis-sensíveis)
- [Execução do Projeto](#execução-do-projeto)
- [Pipeline CI/CD](#pipeline-cicd)
- [Testes Unitários](#testes-unitários)
- [Possíveis Melhorias](#possíveis-melhorias)

---

## Tecnologias Utilizadas

- **Flutter** (3.24.5 ou superior)
- **Dart**
- **Flutter Modular** (Gerenciamento de navegação e injeção de dependências)
- **Flutter Bloc** (Gerenciamento de estado reativo)
- **Firebase** (Autenticação de usuário e Firestore para posts favoritos)
- **JSONPlaceholder** (API para simulação de posts e comentários)
- **GitHub Actions** (CI/CD)
- **JDK 17** (Build para Android)

---

## Recursos Principais

- **Tela de Login**: Autenticação de usuários via Firebase.
- **Tela de Registro**: Criação de novos usuários diretamente no app (funcional).
- **Listagem de Posts**: Visualização de posts com navegação modular.
- **Detalhes de Posts e Comentários**: Exibição detalhada e interação com comentários.
- **Gerenciamento de Estado** via **Cubit/Bloc**.
- **Posts Favoritos Salvos no Firestore**: Cada usuário autenticado pode manter sua lista de favoritos.
- **Integração com JSONPlaceholder** para simulação de endpoints.
- **Envio de Comentários**: Embora o **JSONPlaceholder** forneça um endpoint para envio de comentários, ele não exibe ou salva as informações enviadas. Para simular a adição de um comentário, o sistema envia a informação ao endpoint e adiciona o comentário localmente, proporcionando a experiência de que o comentário foi efetivamente adicionado, sem a necessidade de persistência no backend.

---

## Estrutura do Projeto

```plaintext
blog/
│
├── lib/                    # Código principal do Flutter
│   ├── core/               # Funcionalidades essenciais e configuração global
│   ├── modules/            # Módulos principais (login, registro, home, etc.)
│   ├── shared/             # Recursos compartilhados (ex: use cases, datasources, widgets)
│
├── test/                   # Testes unitários
├── pubspec.yaml            # Gerenciamento de dependências
└── README.md               # Documentação do projeto
```

---

## Configuração do Ambiente

### Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas:

- **Flutter SDK** (3.24.5 ou superior)
- **Dart SDK**
- **Android Studio** ou outro editor compatível com Flutter
- **Java Development Kit (JDK 17)**

### Variáveis Sensíveis

Para rodar o projeto, você precisará de um arquivo **`.env`** no diretório raiz e do **`google-services.json`** no diretório `android/app/`.

1. Baixe o arquivo `google-services.json` do Firebase Console.
2. Coloque-o no diretório `android/app/`.
3. O arquivo `.env` já está incluído no repositório propositalmente com o intuito de ter uma melhor visualização para um projeto apenas de demonstração.

---

## Execução do Projeto

### 1. Instalar Dependências

Execute o seguinte comando para instalar as dependências do Flutter:

```bash
flutter pub get
```

### 2. Rodar a Aplicação

Para rodar o projeto em modo debug:

```bash
flutter run
```

### 3. Gerar Build

Para gerar o APK em modo release:

```bash
flutter build apk --release
```

---

## Pipeline CI/CD

O projeto utiliza **GitHub Actions** para automatizar os seguintes processos:

- **Testes Unitários**: Validações de código com `flutter test --coverage`.
- **Build do APK**: Geração do APK com `flutter build apk --release`.
- **Upload de Artefatos**: Disponibiliza o APK e o relatório de cobertura para download.
- **Criar Tag e Release no GitHub**: cria uma tag e release no GitHub com a versão do aplicativo e o APK gerado.

### Acessando Artefatos

1. Acesse a aba **Actions** no repositório do GitHub.
2. Selecione a execução do workflow desejada.
3. Os artefatos estarão disponíveis para download no final da execução.

---

## Testes Unitários

Os testes foram implementados para validar as seguintes camadas:

- **Use Cases**: Validação da lógica de negócio.
- **Repositórios**: Testes de integração com fontes de dados.
- **Datasources**: Verificação da comunicação correta com APIs e serviços externos.

### Rodando os Testes

Para executar os testes:

```bash
flutter test --coverage
```

---

## Possíveis Melhorias

Com mais tempo e recursos, as seguintes melhorias poderiam ser implementadas no projeto:

1. **Cobertura de Testes Adicionais:**

   - Testar as camadas de **Screen** e **Widgets** para maior confiabilidade.

Essas melhorias enriqueceriam a experiência do usuário e aumentariam a robustez do projeto.

---

Feito com ❤️ e **Flutter**.
