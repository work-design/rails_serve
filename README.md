
# TheRole GUI

 Semantic-ui for the role admin
 
 
## 功能
* 没有权限的链接不显示，不增加一行代码
 
## 默认规则

* 具有编辑权限，则具有读的权限，所以默认对所有规则包含 `admin` 和 `read` 两个rule；

* 记录创建者同样具有对此记录的 admin 权限；


## 使用方式

### Controller

```ruby
# without params
before_action :require_role
  
# with params
before_action do |t|
  require_role params.permit!
end 
```
 
 