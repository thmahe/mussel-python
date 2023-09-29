group "default" {
  targets = [
    "python-38",
    "python-39",
    "python-310",
    "python-311"
  ]
}

target "python-38" {
  dockerfile = "Dockerfile"
  args = {
    PYTHON_VERSION = "3.8.18"
    OPEN_SSL_VERSION = "3.1.3"
  }
  tags = ["8env/mussel-python:3.8"]
}

target "python-39" {
  dockerfile = "Dockerfile"
  args = {
    PYTHON_VERSION = "3.9.18"
    OPEN_SSL_VERSION = "3.1.3"
  }
  tags = ["8env/mussel-python:3.9"]
}

target "python-310" {
  dockerfile = "Dockerfile"
  args = {
    PYTHON_VERSION = "3.10.12"
    OPEN_SSL_VERSION = "3.1.3"
  }
  tags = ["8env/mussel-python:3.10"]
}

target "python-311" {
  dockerfile = "Dockerfile"
  args = {
    PYTHON_VERSION = "3.11.4"
    OPEN_SSL_VERSION = "3.1.3"
  }
  tags = ["8env/mussel-python:3.11"]
}
