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
- [Pipeline CI/CD](#pipeline-ci/cd)
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

- Listagem de posts com navegação modular.
- Visualização detalhada de posts e seus comentários.
- Autenticação de usuário via **Firebase**.
- Posts favoritos salvos no **Firestore** vinculados ao usuário autenticado.
- Gerenciamento de estado via **Cubit/Bloc**.
- Pipeline CI/CD com testes unitários, build do APK e upload automatizado de artefatos.
- Integração com API falsa (**JSONPlaceholder**) para simulação de endpoints.

---

## Estrutura do Projeto

```plaintext
blog/
│
│
├── lib/                    # Código principal do Flutter
│   ├── core/               # Funcionalidades essenciais e configuração global
│   │
│   ├── modules/            # Módulos principais
│   │
│   ├── shared/             # Recursos compartilhados (ex: use cases, datasources)
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

   - Testar as camadas de **Bloc**, **Screen** e **Widgets** para maior confiabilidade.

2. **Tela de Criação de Usuário:**

   - Permitir que novos usuários se registrem diretamente no aplicativo.

3. **Adicionar Comentários:**
   - Implementar funcionalidade para que os usuários possam adicionar comentários aos posts diretamente pela interface.

Essas melhorias enriqueceriam a experiência do usuário e aumentariam a robustez do projeto.

---

Feito com ❤️ e **Flutter**.
