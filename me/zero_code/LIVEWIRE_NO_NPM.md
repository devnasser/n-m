### Livewire v3 بلا أدوات بناء

- التثبيت: `composer require livewire/livewire:^3`
- المتطلبات الأمامية: AlpineJS عبر CDN (اختياري)، Bootstrap عبر CDN.

- إنشاء مكوّن CRUD بسيط:
```bash
php artisan make:livewire posts.table
```

- مثال مبسّط للمكوّن (Posts/Table):
```php
use Livewire\Component;
use App\Models\Post;
use Livewire\WithPagination;

class Table extends Component
{
    use WithPagination;
    public string $search = '';

    public function render()
    {
        $posts = Post::query()
            ->when($this->search, fn($q) => $q->where('title','like',"%{$this->search}%"))
            ->latest()->paginate(10);
        return view('livewire.posts.table', compact('posts'));
    }
}
```

- Blade للمكوّن:
```blade
<div>
  <input class="form-control mb-3" placeholder="ابحث" wire:model.debounce.300ms="search">
  <table class="table table-striped">
    <thead><tr><th>#</th><th>العنوان</th><th>تاريخ</th></tr></thead>
    <tbody>
      @foreach($posts as $post)
        <tr>
          <td>{{ $post->id }}</td>
          <td>{{ $post->title }}</td>
          <td>{{ $post->created_at->format('Y-m-d') }}</td>
        </tr>
      @endforeach
    </tbody>
  </table>
  {{ $posts->links() }}
</div>
```

- إدراج المكوّن في صفحة:
```blade
@extends('layouts.app')
@section('content')
  <h1 class="h4 mb-3">المنشورات</h1>
  <livewire:posts.table />
@endsection
```

- ملاحظات:
  - لا حاجة لـ npm. استعمل CDN لـ Bootstrap/Alpine.
  - ارفع الملفات باستخدام Livewire مباشرةً (يعتمد على إعداد PHP /tmp).