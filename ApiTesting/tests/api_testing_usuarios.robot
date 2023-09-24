*** Settings ***
Resource    ../resources/api_testing_usuarios_resource.robot

*** Variables ***

*** Test Cases ***
Cenário 01: Cadastrar um novo usuário com sucesso na ServeRest
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest    email=${EMAIL_TEST}    status_code_desejado=201
    Conferir se o usuário foi cadastrado corretamente

Cenário 02: Cadastrar o usuário existente ( para testes negativo)
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest    email=${EMAIL_TEST}    status_code_desejado=201
    Vou repetir o cadastrado do usuário
    Verificar se a API não permitiu o cadastro repetido

Cenário 03: Consultar os dados de um novo usuário
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest     email=${EMAIL_TEST}    status_code_desejado=201
    Consultar os dados do novo usuário
    Conferir os dados retornados