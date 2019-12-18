# Elixir Bank (Desafio Técnico)

[![Build Status](https://travis-ci.org/t00lmaker/elixir-bank.svg?branch=master)](https://travis-ci.org/t00lmaker/elixir-bank)
[![Coverage Status](https://coveralls.io/repos/github/t00lmaker/elixir-bank/badge.svg?branch=master)](https://coveralls.io/github/t00lmaker/elixir-bank?branch=master)
[![Inline docs](http://inch-ci.org/github/t00lmaker/elixir-bank.svg?branch=HEAD)](http://inch-ci.org/github/t00lmaker/elixir-bank)

Desafio técnico para criação de uma API de um banco utlizando Elixir.


## O que vai encontrar aqui ?
 Uma API REST impleementada utilizando [Elixir](https://elixir-lang.org/) e o framwork [Phoenix](https://www.phoenixframework.org) que simula um sistema bancario simples. Além disso, essa é uma aplicação 'dockerizada' juntamente com um banco de dados Postgres em um docker-compose.

## Features
  
1. Login com [JWT](https://jwt.io/)
2. Cadastro de Clientes
3. Operações bancarias:
    - Saque de conta.
    - Depositos em conta.
    - Transferências entre contas.
4. Relátorio de Transaçẽs por dia, mês, ano e total. 

## API

A documentação da API pode ser encontrada [aqui](https://documenter.getpostman.com/view/593922/SWECWF1b). 

## Setup

Essa é uma aplicação Elixir, preparada para gerar uma [release](https://hexdocs.pm/mix/Mix.Tasks.Release.html#module-why-releases) para entregar código em produção.
Esse mesmo pacote pode ser colocado em um docker container e ser "deployado" como unidade. 
Além disso, permite que a execução de uma unidade mais abrangente, o docker-compose.

Abaixo duas formas execução da aplicação:

#### Servidor Local

Para executar dessa forma é necessário um postgres rodando e configurado nas 
os arquivos de configuração da aplicação, que são os mesmo de qualquer aplicação 
Phoenix.

```

mix ecto.setup
mix phx.server

```

#### Docker Compose

Presumindo que já tenha o Docker e Docker Compose instalado, execute o comando abaixo.  

```

docker-compose up

```

Nessa abordagem uma release será construida, dockerizada e executada em um ambiente 
configurado com banco de dados preparado para conexão.

Em ambas as abordagem um usuário admin com password adminAdmin é criado e ficará pronto para uso segundo a 
especificação da [API](https://documenter.getpostman.com/view/593922/SWECWF1b). 

## Modelo

## Testes

Testes podem ser executados com o seguinte comando:

```

mix test

```

Pode-se ver a cobertura dos testes utilizando o seguinte commando:

```

mix converalls

```

## TODOs

Veja as Issues do repositório.
