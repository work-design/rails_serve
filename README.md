# RailsRole

[![测试](https://github.com/work-design/rails_role/actions/workflows/test.yml/badge.svg)](https://github.com/work-design/rails_role/actions/workflows/test.yml)
[![Docker构建](https://github.com/work-design/rails_role/actions/workflows/cd.yml/badge.svg)](https://github.com/work-design/rails_role/actions/workflows/cd.yml)
[![Gem](https://github.com/work-design/rails_role/actions/workflows/gempush.yml/badge.svg)](https://github.com/work-design/rails_role/actions/workflows/gempush.yml)

RailsRole 是一个基于Controller/Action的Rails权限控制系统，开箱即用，全程UI配置。
 
## 特性
* 没有权限的链接不显示，不增加一行代码

覆写了 link_to 方法，如果该链接不具备权限，则不显示；

html_options 支持 text 选项，如果 text 为 true, 则不具备权限的链接显示链接内容；


## 默认规则

* 具有编辑权限，则具有读的权限，所以默认对所有规则包含 admin 和 read 两个 rule；
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
 
## 许可证
遵循 [MIT](https://opensource.org/licenses/MIT) 协议
