# 🧪 Guia de Testes da Aplicação POMBUS

## Teste Local Sem API Real

Para testar a aplicação sem ter a API implementada ainda, você pode usar os dados mock:

### 1. Usar Dados Mock

Edite `lib/services/api_service.dart` e modifique os métodos para retornar dados mock:

```dart
// No método login
Future<User> login(String email, String password) async {
  // Comentar requisição HTTP real
  // final response = await http.post(...)
  
  // Usar dados mock em vez disso
  return MockData.getMockUser();
}

// No método getServices
Future<List<Service>> getServices({...}) async {
  // return await http.get(...)  // Comentar
  return MockData.getMockServices();
}

// No método getMyBookings
Future<List<Booking>> getMyBookings() async {
  // return await http.get(...)  // Comentar
  return MockData.getMockBookings();
}
```

### 2. Credenciais de Teste

Com dados mock, qualquer email/senha funciona:
- **Email**: `test@example.com`
- **Senha**: `password123`

### 3. Dados de Teste Inclusos

#### Serviços Disponíveis
1. **Ônibus Premium Lisboa-Porto** - €25.50
2. **Comboio Alfa Lisboa-Covilhã** - €45.00
3. **Voo TAP Lisboa-Porto** - €89.99
4. **Ferry Setúbal-Tróia** - €12.00 (Indisponível)
5. **Ônibus Express Porto-Braga** - €15.75

#### Reservas do Utilizador
1. Reserva Confirmada (Ônibus Lisboa-Porto)
2. Reserva Pendente (Voo Lisboa-Porto)
3. Reserva Completa (Comboio Lisboa-Covilhã)


## Fluxo de Teste Completo

### 1. Teste de Login
```
1. Abra a aplicação
2. Clique em "Entrar"
3. Digite qualquer email e senha
4. Clique em "Entrar"
5. ✅ Deve ir para a Home
```

### 2. Teste de Registro
```
1. Na tela Login, clique "Registar-se"
2. Preencha: nome, email, senha (2x)
3. Clique "Registar-se"
4. ✅ Deve ir para a Home
```

### 3. Teste de Navegação
```
1. Home (padrão)
2. Toque no ícone "Reservas" → vai para Minhas Reservas
3. Toque no ícone "Perfil" → vai para Perfil
4. Toque "Sair" → volta para Login
5. ✅ Navegação funciona
```

### 4. Teste de Busca
```
1. Na Home, digite "ônibus" na busca
2. ✅ Deve filtrar serviços com "ônibus"
3. Limpe o campo
4. ✅ Deve voltar à lista completa
```

### 5. Teste de Filtro por Categoria
```
1. Na Home, clique em categoria "Ónibus"
2. ✅ Deve mostrar apenas serviços de ônibus
3. Clique em "Todos"
4. ✅ Deve mostrar todos novamente
```

### 6. Teste de Detalhes do Serviço
```
1. Clique em qualquer serviço da Home
2. ✅ Deve abrir a tela de detalhes
3. Preencha origem, destino, data
4. Inclua 2 passageiros
5. Clique "Confirmar Reserva"
6. ✅ Deve voltar com mensagem de sucesso
```

### 7. Teste de Minhas Reservas
```
1. Vá para "Minhas Reservas"
2. ✅ Deve listar as 3 reservas de teste
3. Clique em uma reserva
4. ✅ Deve mostrar detalhes completos
5. Se confirmada, toque "Cancelar"
6. ✅ Deve remover da lista
```

### 8. Teste de Perfil
```
1. Vá para "Perfil"
2. ✅ Deve mostrar dados do utilizador
3. Clique "Sair"
4. ✅ Deve voltar para Login
```


## Teste em Diferentes Plataformas

### macOS
```bash
flutter run -d macos

# Testar:
# - Redimensionar janela
# - Keyboard shortcuts (Cmd+Q para sair)
# - Scroll natural do macOS
```

### Windows
```bash
flutter run -d windows

# Testar:
# - Janela redimensionável
# - Maximizar/Minimizar
# - Tema claro/escuro do sistema
```


## Casos de Teste - Validação

### Campos Obrigatórios
- [ ] Login: Email vazio → mostrar erro
- [ ] Login: Senha vazia → mostrar erro
- [ ] Registro: Qualquer campo vazio → mostrar erro
- [ ] Registro: Senhas diferentes → mostrar erro
- [ ] Reserva: Origem vazia → mostrar erro
- [ ] Reserva: Destino vazio → mostrar erro

### Limites
- [ ] Passageiros mínimo: 1
- [ ] Passageiros máximo: 10
- [ ] Busca pode estar vazia
- [ ] Notas da reserva são opcionais

### Estados Visuais
- [ ] Botões desabilitados durante carregamento
- [ ] Loading spinner durante requisições
- [ ] Mensagens de erro visíveis
- [ ] Status de reserva com cores corretas


## Checklist de Testes Recomendados

### Interface
- [ ] Todos os botões funcionam
- [ ] Scroll funciona em listas
- [ ] Formatação de data/moeda está correta
- [ ] Ícones aparecem corretamente
- [ ] Layout responsivo em diferentes tamanhos

### Funcionalidade
- [ ] Login e Logout funcionam
- [ ] Dados persistem após navegação
- [ ] Busca filtra corretamente
- [ ] Criar reserva atualiza lista
- [ ] Cancelar reserva remove da lista
- [ ] Detalhes carregam corretamente

### Performance
- [ ] App carrega em < 2 segundos
- [ ] Listas scrollam sem lag
- [ ] Transições são suaves
- [ ] Sem memory leaks (testar por 30min)


## Relatório de Testes

Use este template para documentar testes:

```
Projeto: POMBUS Flutter
Data: ___/___/______
Plataforma: macOS / Windows
Versão Flutter: _________

Testes Executados:
- [ ] Login
- [ ] Registro
- [ ] Listagem de Serviços
- [ ] Busca
- [ ] Filtro
- [ ] Criar Reserva
- [ ] Ver Reservas
- [ ] Cancelar Reserva
- [ ] Perfil
- [ ] Logout

Problemas Encontrados:
1. ...
2. ...

Testes Passados: __/12
Testes Falhados: __/12

Observações:
...
```


## Dicas para Testes Manuais

1. **Use DevTools do Flutter**
   ```bash
   flutter run -d macos --observatory-url
   ```

2. **Teste com modo Debug**
   ```bash
   flutter run -d macos
   ```

3. **Teste com Release (mais realista)**
   ```bash
   flutter run -d macos --release
   ```

4. **Verifique Logs**
   ```bash
   flutter logs
   ```

5. **Teste Performance**
   - Abra DevTools
   - Vá para Performance tab
   - Grave interações
   - Analise FPS e jank


---

**Próximo Passo**: Quando a API estiver pronta, remova os dados mock e configure os endpoints reais.
