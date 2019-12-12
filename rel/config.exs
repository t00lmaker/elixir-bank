use Distillery.Releases.Config

# configura o release para o ambiente de prod.
environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"TkJlF,3ewe4)OWPBpPxPDb6te4z$>)>a>/v/,l2}W*sUFaz<)bG,v*3pPESE,`XOk{,"
  set vm_args: "rel/vm.args"
  set post_start_hooks: "rel/hooks/post_start"
end

release :bankapi do
  set version: current_version(:bankapi)
end
