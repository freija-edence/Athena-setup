if [ $(docker ps --filter "name=etl" | grep -w 'etl' | wc -l) = 1 ]; then
  docker stop -t 1 etl && docker rm etl;
fi

curl -L https://raw.githubusercontent.com/solventrix/Athena-setup/master/RunETLKWSUC/docker-compose.yml --output docker-compose.yml

read -p "Input Data folder [./data]: " data_folder
data_folder=${data_folder:-./data}
read -p "DB username [athena_admin]: " db_username
db_username=${db_username:-athena_admin}
read -p "DB password [athena_admin]: " db_password
db_password=${db_password:-athena_admin}
read -p "Output verbosity level [INFO]: " verbosity_level
verbosity_level=${verbosity_level:-INFO}
read -p "Docker Hub image tag [current]: " image_tag
image_tag=${image_tag:-current}

sed -i -e "s@data_folder@$data_folder@g" docker-compose.yml
sed -i -e "s/db_username/$db_username/g" docker-compose.yml
sed -i -e "s/db_password/$db_password/g" docker-compose.yml
sed -i -e "s/verbosity_level/$verbosity_level/g" docker-compose.yml
sed -i -e "s/image_tag/$image_tag/g" docker-compose.yml

docker login harbor-uat.athenafederation.org
docker-compose pull
docker-compose run --rm --name etl etl
