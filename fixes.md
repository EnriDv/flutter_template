# flutter_template

Aplicación Flutter para gestionar transferencias entre cuentas bancarias.

## Estructura del Proyecto

```
lib/
├── core/
│   └── constants/
│       └── app_routes.dart          # Constantes centralizadas de rutas
├── features/
│   └── transfer/
│       └── pages/
│           ├── transfer_page.dart   # Pantalla de transferencia
│           └── confirm_page.dart    # Pantalla de confirmación
├── models/
│   └── account.dart                 # Modelo de datos: Account
├── pages/
│   └── home_page.dart              # Pantalla de inicio
├── widgets/
│   ├── account_list_tile.dart
│   ├── transfer_result_box.dart
│   └── transfer_summary_card.dart
└── main.dart                        # Punto de entrada
```

## Errores y Malas Prácticas Corregidas

### 1. **Rutas Hardcodeadas en Widgets** ❌→✅
**Problema:**
- Las rutas estaban hardcodeadas como strings en varios archivos (ej: `'/transfer'`)
- Los nombres de argumentos también estaban hardcodeados (ej: `'sourceAccount'`)
- Cualquier cambio en una ruta requería actualizar múltiples archivos

**Solución:**
- Creado `lib/core/constants/app_routes.dart` con constantes centralizadas
- Todas las rutas y claves de argumentos ahora se definen en un solo lugar
- Cambiar una ruta solo requiere modificar `AppRoutes`

```dart
// ❌ ANTES (main.dart)
routes: {
  '/transfer': (context) => const TransferPage(),
},

// ✅ DESPUÉS (main.dart)
routes: {
  AppRoutes.transfer: (context) => const TransferPage(),
},

// ❌ ANTES (home_page.dart)
Navigator.pushNamed(context, '/transfer', arguments: {
  'sourceAccount': account,
  'allAccounts': accounts,
});

// ✅ DESPUÉS (home_page.dart)
Navigator.pushNamed(context, AppRoutes.transfer, arguments: {
  AppRoutes.argSourceAccount: account,
  AppRoutes.argAllAccounts: accounts,
});
```
commit: https://github.com/EnriDv/flutter_template/commit/9eb1f0ed9451c199c1f4c652fd6b4814cbda9c64

---

### 2. **Doble Pop Después de Confirmar Transferencia** ❌→✅
**Problema:**
- En `transfer_page.dart`, después de recibir resultado de `ConfirmPage`, se hacía:
  ```dart
  if (result != null && result is Map<String, Account>) {
    // ... mostrar snackbar ...
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.pop(context, result);  // ← DOBLE POP
    });
  }
  ```
- El `Navigator.push()` ya manejaba el resultado correctamente
- El `Future.delayed + Navigator.pop()` causaba un segundo pop innecesario
- Esto podría causar problemas de navegación

**Solución:**
- Eliminado el `Future.delayed` y el pop innecesario
- El resultado de `ConfirmPage` se retorna directamente
- Un solo pop devuelve el resultado al home_page

```dart
// ❌ ANTES
final result = await Navigator.push(...);
if (result != null && result is Map<String, Account>) {
  setState(() {...});
  ScaffoldMessenger.of(context).showSnackBar(...);
  
  Future.delayed(const Duration(milliseconds: 1000), () {
    Navigator.pop(context, result);  // Doble pop
  });
}

// ✅ DESPUÉS
final result = await Navigator.push(...);
if (result != null && result is Map<String, Account>) {
  setState(() {...});
  _showSuccessSnackBar(_result);
  
  if (mounted) {
    Navigator.pop(context, result);  // Un solo pop con resultado
  }
}
```

commit: https://github.com/EnriDv/flutter_template/commit/47609974e648484a8398213e0a02621d1e8eb637

---

### 3. **Pop Sin Retorno de Valores** ❌→✅
**Problema:**
- En `confirm_page.dart`, el botón "Cancelar" hacía:
  ```dart
  Navigator.pop(context);  // ← Sin retornar nada
  ```
- Esto devuelve `null` implícitamente, haciendo código confuso
- El flujo no es explícito sobre qué significa cancelar

**Solución:**
- Ahora el botón cancela devuelve explícitamente `null`
- La documentación del widget explica qué retorna cada caso
- El manejo en `transfer_page.dart` es más claro

```dart
// ❌ ANTES
OutlinedButton(
  onPressed: () {
    Navigator.pop(context);  // ¿Qué devuelve?
  },
  child: const Text('Cancelar'),
),

// ✅ DESPUÉS
OutlinedButton(
  onPressed: () {
    // Devolver null para indicar cancelación
    Navigator.pop(context, null);
  },
  child: const Text('Cancelar'),
),
```

Documentación en `ConfirmPage`:
```dart
/// Retorna:
/// - Map<String, Account> si se confirma (ambas cuentas actualizadas)
/// - null si se cancela
```

commit: https://github.com/EnriDv/flutter_template/commit/47609974e648484a8398213e0a02621d1e8eb637


---

### 4. **Validaciones Duplicadas** ❌→✅
**Problema:**
- Las validaciones de transferencia estaban dispersas en el `onPressed`
- Código difícil de leer y mantener
- Difícil de reutilizar

**Solución:**
- Creada función `_validateTransfer()` que centraliza todas las validaciones
- Código más limpio, legible y mantenible
- Fácil de agregar nuevas validaciones

```dart
// ❌ ANTES
if (_amountController.text.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(...);
  return;
}
if (amount == null || amount <= 0) {
  ScaffoldMessenger.of(context).showSnackBar(...);
  return;
}
if (amount > sourceAccount.balance) {
  ScaffoldMessenger.of(context).showSnackBar(...);
  return;
}
if (_destinationAccount == null) {
  ScaffoldMessenger.of(context).showSnackBar(...);
  return;
}

// ✅ DESPUÉS
String? _validateTransfer(Account sourceAccount) {
  if (_amountController.text.isEmpty) return 'Por favor ingresa un monto';
  
  final amount = double.tryParse(_amountController.text);
  if (amount == null || amount <= 0) return 'Monto inválido';
  if (amount > sourceAccount.balance) return 'Saldo insuficiente';
  if (_destinationAccount == null) return 'Selecciona una cuenta destino';
  
  return null;
}

// Uso:
final validationError = _validateTransfer(sourceAccount);
if (validationError != null) {
  _showErrorSnackBar(validationError);
  return;
}
```

commit: https://github.com/EnriDv/flutter_template/commit/1e969847c4ff255431182e98d9ccf9bd1d451e79

---

### 5. **Métodos de Utilidad para SnackBars** ✨
**Mejora:**
- Centralizadas las funciones para mostrar SnackBars
- Código más limpio y reutilizable
- Consistencia en la presentación de mensajes

```dart
void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}

void _showSuccessSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.green),
  );
}
```

commit: https://github.com/EnriDv/flutter_template/commit/1e969847c4ff255431182e98d9ccf9bd1d451e79

---

---

## Flujo de la Aplicación

```
┌─────────────┐
│  home_page  │  ← Lista de cuentas del usuario
└──────┬──────┘
       │ pushNamed (/transfer)
       ├─ argSourceAccount: Account
       └─ argAllAccounts: List<Account>
       │
       ▼
┌─────────────────┐
│ transfer_page   │  ← Seleccionar destino y monto
└──────┬──────────┘
       │ push (ConfirmPage)
       │
       ▼
┌─────────────────┐
│ confirm_page    │  ← Confirmar o cancelar
└──────┬──────────┘
       │
       ├─ Confirmar → retorna Map<String, Account>
       └─ Cancelar  → retorna null
       │
       ▼
┌─────────────────┐
│ transfer_page   │  ← Recibe resultado
└──────┬──────────┘
       │ pop (con resultado)
       │
       ▼
┌─────────────┐
│ home_page   │  ← Actualiza cuentas y las lista
└─────────────┘
```
