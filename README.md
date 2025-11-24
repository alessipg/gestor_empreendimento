# ReceiTáCerta

O ReceiTáCerta procura facilitar a gestão de empreendimentos com foco em produção de alimentos, onde se faz necessário o constante cálculo de custos de produção. Este app foi feito como requisito da disciplina de Programação de Dispositivos Móveis na UTFPR-PG, ministrada pelo professor [Diego Antunes](https://github.com/drantunes).

---
## Colaboradores
- [Gabriel Alessi](https://github.com/alessipg)
- [Helena Rentschler](https://github.com/helenarentschler)
---
## Como rodar (resumo)
Requisitos usados no desenvolvimento:
- `Flutter version: 3.35.0`
- `Dart SDK version: 3.9.0`
- Android Studio/SDK e emulador ou dispositivo físico Android
- Git
- Conta Firebase (gratuita)

### Configuração inicial

1. Clone o repositório
2. Copie o arquivo de exemplo de variáveis de ambiente:
   ```powershell
   Copy-Item .env.example .env
   ```
3. Configure suas credenciais do Firebase no arquivo `.env` (veja seção [Configuração do Firebase](#configuração-do-firebase))

Instalar dependências e rodar:
```powershell
flutter pub get
flutter run
```

### Configuração do Firebase

Este projeto utiliza Firebase para autenticação. Para configurar:

1. Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
2. Adicione um app Android e/ou Web ao projeto
3. Copie as credenciais para o arquivo `.env`:

```env
# Android
FIREBASE_API_KEY_ANDROID=sua_chave_android_aqui
FIREBASE_APP_ID_ANDROID=seu_app_id_android_aqui
FIREBASE_MESSAGING_SENDER_ID=seu_sender_id_aqui
FIREBASE_PROJECT_ID=seu_project_id_aqui
FIREBASE_STORAGE_BUCKET=seu_storage_bucket_aqui

# Web
FIREBASE_API_KEY_WEB=sua_chave_web_aqui
FIREBASE_APP_ID_WEB=seu_app_id_web_aqui
FIREBASE_AUTH_DOMAIN=seu_auth_domain_aqui
FIREBASE_MEASUREMENT_ID=seu_measurement_id_aqui
```

4. **IMPORTANTE**: Nunca commite o arquivo `.env` no Git! Ele já está no `.gitignore` por segurança.

5. Para obter as credenciais:
   - **Android**: Project Settings > Your apps > Android app > Config
   - **Web**: Project Settings > Your apps > Web app > Config

6. Configure as restrições de segurança no Firebase Console:
   - **Authentication > Settings**: limitar domínios autorizados
   - **Google Cloud Console > Credentials**: restringir API Keys por package name (Android) ou referrer (Web)

## Desenvolvimento

### Versionamento
O projeto está sendo desenvolvido utilizando Git para o controle de versões. As branchs seguem a seguinte organização:

- `main:` Nesta branch fica a versão final de cada entrega (são previstas três no planejamento de aula).
- `dev:` Branch focada para o merge das novas funcionalidades ou correções, sempre igual ou à frente da `main`.
- Todas as demais sempre irão seguir padrões como os sugeridos pelo [Conventional Commits](https://conventionalcommits.org/) (`fix`,`feat`,`refactor`) ou nome do integrante que colaborou.

### Tech Stacks
O aplicativo foi desenvolvido utilizando o framework Flutter, com uso focado na plataforma Android. 
  

Os seguintes packages foram utilizados no projeto:

- `go_router`: Organização de rotas do aplicativo.
- `provider`: Injeções de dependência e controle de estado.
- `diacritic`: Remoção de acentos e caracteres especiais para buscas por nome.  
- `intl`: Formatação com base na localização.
- `flutter_launcher_icons`: Manipulação de ícones.
- `sqflite`: Persistência local (SQLite).
- `firebase_core` e `firebase_auth`: Autenticação via Google.
- `google_sign_in`: Integração com login do Google.
  
#### Arquitetura
A arquitetura escolhida para a estrutura do projeto foi a MVC.

### Pré-requisitos
- Flutter SDK (3.x+) e Dart (compatível com a versão do Flutter)
- Android Studio/SDK e um emulador ou dispositivo Android
- Git instalado

Verifique a instalação:

```powershell
flutter --version
dart --version
```

### Como rodar
```powershell
# Instalar dependências
flutter pub get

# Rodar no dispositivo/emulador conectado
flutter run
```

Opcional (gerar APK release):
```powershell
flutter build apk --release
```

### Como rodar testes
Há testes unitários em `test/insumo_controller_test.dart` e `test/receita_controller_test.dart`, que foram feitos apenas para confirmar a regra de negócio. É possível rodá-los com:
```powershell
flutter test
```

### Estrutura do projeto (resumo)
- `lib/config`: constantes e enums (ex.: `Medida`)
- `lib/controllers`: camada de controle (Provider) — `InsumoController`, `ReceitaController`, `MercadoriaController`
- `lib/models`: entidades de domínio (`Insumo`, `Receita`, `Mercadoria`, `Produto`)
- `lib/repositories`: repositórios com persistência em SQLite
- `lib/database`: configuração do banco de dados local (SQLite)
- `lib/security`: serviços de autenticação (Google Sign-In)
- `lib/views/pages`: telas (insumos, receitas, etc.)
- `lib/utils`: utilitários (ex.: formatadores de entrada)
- `assets/`: imagens e fontes
- `test/`: testes unitários

### Arquitetura (detalhes)
- Padrão MVC
	- Model: `lib/models/*`
	- Controller: `lib/controllers/*` (gerenciados via Provider)
	- View: `lib/views/*`
- Roteamento: `go_router`
- Estado/DI: `provider`
- Internacionalização/Formatação: `intl`
- Busca sem acentos: `diacritic`
- Persistência: SQLite via `sqflite`
- Autenticação: Firebase Auth + Google Sign-In

---
## Aplicação

A principal funcionalidade do aplicativo é realizar o cálculo automático de uma receita. 
Três entidades principais compôem esse processo:

- Insumo: produtos matéria-prima, são os utilizados para a produção de uma receita.
- Receita: O ator principal que ligará mercadoria com insumos. Este é responsável por estimar o custo de produção unitário da mercadoria.
- Mercadoria: o produto resultante de uma receita e que será vendido para alguém.

### Funcionalidades atuais
- Insumos
	- Criar/editar insumos
	- Formatação de valores e quantidades com `CurrencyInputFormatter` e `QuantityInputFormatter`
	- Cálculo de custo por unidade (com suporte a vírgula/ponto e entrada RTL para quantidades)
- Receitas
	- Tela de criação com:
		- Seleção de produto final (mercadoria) e quantidade produzida
		- Dropdown de matérias-primas (insumos) com quantidade por receita
		- Lista das matérias-primas adicionadas com remoção
	- Integração com `ReceitaController` para criar a receita
- Mercadorias
    - Criar/Editar
    - Visualizar custos

### Convenções e qualidade
- Commits: Conventional Commits (ex.: `feat:`, `fix:`, `refactor:`)
- Branches: `main`, `dev` e feature branches (`feat/*`, `fix/*`, `refactor/*`)
- Lint/format:
```powershell
flutter format .
dart analyze
```
### Funcionalidades a acrescentar
>Com exceção das obrigatórias, as demais dependerão do tempo disponível dos colaboradores.
- [ ] Persistência (ex.: Hive/Sqflite)
- [ ] Estoque: entrada/saída integrada às receitas
- [ ] Relatórios de custo/margem
- [ ] Autenticação com Google
- [ ] PDV com QRCode


### Licença
Este projeto é um trabalho acadêmico da disciplina de Programação de Dispositivos Móveis na UTFPR-PG. O código é licenciado sob a **MIT License**. Consulte o arquivo [`LICENSE`](./LICENSE) para mais detalhes.


