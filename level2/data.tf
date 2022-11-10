data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "tf-state-20221102"
    key    = "level1.tfstate"
    region = "ap-northeast-1"
  }
}