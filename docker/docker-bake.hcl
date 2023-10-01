group "default" {
  targets = [
    "python-38",
    "python-38-win",
    "python-39",
    "python-39-win",
    "python-310",
    "python-310-win",
    "python-311",
    "python-311-win",
  ]
}

target "python-38" {
  dockerfile = "linux.Dockerfile"
  args = {
    PYTHON_VERSION = "3.8.18"
    OPEN_SSL_VERSION = "3.1.3"
  }
  tags = ["8env/mussel-python:3.8"]
}

target "python-38-win" {
  dockerfile = "windows.Dockerfile"
  args = {
    PYTHON_VERSION = "3.8.10"
  }
  tags = ["8env/mussel-python:3.8-win"]
}

target "python-39" {
  dockerfile = "linux.Dockerfile"
  args = {
    PYTHON_VERSION = "3.9.13"
    OPEN_SSL_VERSION = "3.1.3"
  }
  tags = ["8env/mussel-python:3.9"]
}

target "python-39-win" {
  dockerfile = "windows.Dockerfile"
  args = {
    PYTHON_VERSION = "3.9.13"
  }
  tags = ["8env/mussel-python:3.9-win"]
}

target "python-310" {
  dockerfile = "linux.Dockerfile"
  args = {
    PYTHON_VERSION = "3.10.12"
    OPEN_SSL_VERSION = "3.1.3"
  }
  tags = ["8env/mussel-python:3.10"]
}

target "python-310-win" {
  dockerfile = "windows.Dockerfile"
  args = {
    PYTHON_VERSION = "3.10.11"
  }
  tags = ["8env/mussel-python:3.10-win"]
}

target "python-311" {
  dockerfile = "linux.Dockerfile"
  args = {
    PYTHON_VERSION = "3.11.5"
    OPEN_SSL_VERSION = "3.1.3"
  }
  tags = ["8env/mussel-python:3.11"]
}

target "python-311-win" {
  dockerfile = "windows.Dockerfile"
  args = {
    PYTHON_VERSION = "3.11.5"
  }
  tags = ["8env/mussel-python:3.11-win"]
}