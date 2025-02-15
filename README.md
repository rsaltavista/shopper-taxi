# ShopperTaxi

ShopperTaxi é um aplicativo de solicitação de viagens desenvolvido para iOS utilizando **Swift**, **SwiftUI** e **UIKit**, seguindo a **arquitetura MVVM** (Model-View-ViewModel). O aplicativo permite aos usuários estimar viagens, selecionar motoristas e visualizar o histórico de corridas.

## 📌 Funcionalidades Principais

- 📍 **Solicitação de Viagens**: O usuário pode inserir o local de origem e destino para obter estimativas de preço e tempo.
- 🚗 **Escolha do Motorista**: Os motoristas disponíveis variam conforme a distância da viagem.
- 🕒 **Histórico de Viagens**: Exibição de viagens anteriores com detalhes como data, motorista e valor.
- 🚀 **Arquitetura Limpa e Modular**: Código organizado para facilitar manutenção e expansão.
- ✅ **Testes Unitários**: Implementação de testes para garantir a qualidade do código.

## 🔧 Decisões de Arquitetura

1. **Arquitetura MVVM**: Separação clara entre a lógica de negócios e a interface, garantindo modularidade e testabilidade.
2. **Injeção de Dependência**: Utilização de protocolos (`RideServiceProtocol`, `NetworkManagerProtocol`) para facilitar substituições e testes.
3. **Tratamento de Erros**: Implementação de um sistema robusto para lidar com erros de rede e entrada de dados do usuário.
4. **Testes Unitários**: Cobertura de testes para garantir o correto funcionamento dos ViewModels e serviços.

## 🧪 Testes Implementados

- **Mocks e Stubs** para simular respostas da API.
- **Testes Assíncronos** para chamadas de rede e lógica de negócios.
- **Cobertura de Cenários de Erro** para validar tratamentos no aplicativo.

## 🚀 Como Rodar o Projeto

1. **Clone o repositório**:
   git clone [https://github.com/rsaltavista/shopper-taxi.git]

2. **Abra o projeto no Xcode** 

3. **Execute no simulador ou no dispositivo físico**
