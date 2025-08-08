### الوحدات وحدود المسؤولية

| الوحدة | المسؤوليات | الواجهات |
|---|---|---|
| Schema Builder | قراءة SCHEMA.json، توليد Migrations/Models/Policies | `SchemaBuilder::build(schema)` |
| Component Factory | توليد Blade/Livewire CRUD | `ComponentFactory::generate(resource)` |
| Business Logic | قواعد التحقّق، Observers/Events | `RulesService`, `Event` |
| API Layer | Resource Controllers/Requests/Resources | REST `/api/{resource}` |
| Auth/RBAC | Gates/Policies وأدوار | `can($ability)` |
| Persistence | Repositories لـ Eloquent | `PostRepository` |
| UI | Layout + Bootstrap + Components | Blade sections |
| Tooling | Composer/Pest/CI | scripts `gen`, `test` |

- مبادئ:
  - عزل concerns، عقود واضحة، يمنع تسرّب تفاصيل التخزين.