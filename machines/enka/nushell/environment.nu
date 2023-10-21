let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |string|
      $string
      | split row (char esep)
      | path expand -n
    }
    to_string: { |value|
      $value
      | path expand -n
      | str join (char esep)
    }
  }
}

$env.NU_LIB_DIRS = [
    ($nu.config-path
     | path dirname
     | path join 'scripts')
]

$env.NU_PLUGIN_DIRS = [
    ($nu.config-path
     | path dirname
     | path join 'plugins')
]
