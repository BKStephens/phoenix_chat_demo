# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ChatDemo.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
ChatDemo.Repo.insert!(%ChatDemo.User{"email": "testuser1@gmail.com", "password": "foobar", "crypted_password": Comeonin.Bcrypt.hashpwsalt("foobar")})
ChatDemo.Repo.insert!(%ChatDemo.User{"email": "testuser2@gmail.com", "password": "foobar", "crypted_password": Comeonin.Bcrypt.hashpwsalt("foobar")})
ChatDemo.Repo.insert!(%ChatDemo.User{"email": "testuser3@gmail.com", "password": "foobar", "crypted_password": Comeonin.Bcrypt.hashpwsalt("foobar")})
