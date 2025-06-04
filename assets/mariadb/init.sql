# Recreate the Hibernate-generated schema SQL with "USE mariadb;" prepended
# Important Notice: This SQL script is designed to be run in a MariaDB database environment
USE mariadb;

create table adoption (
    request_id integer not null auto_increment,
    status tinyint check (status between 0 and 3),
    citizen_id integer,
    shelter_id integer,
    pet_id integer,
    primary key (request_id)
) engine=InnoDB;

create table citizen (
    address varchar(30) not null,
    first_name varchar(30) not null,
    last_name varchar(30) not null,
    id integer not null,
    primary key (id)
) engine=InnoDB;

create table contact (
    id integer not null auto_increment,
    message varchar(255),
    scheduled_visit datetime(6),
    status tinyint check (status between 0 and 3),
    citizen_id integer,
    shelter_id integer,
    primary key (id)
) engine=InnoDB;

create table health_check (
    examination_id integer not null auto_increment,
    details varchar(200),
    status tinyint check (status between 0 and 3),
    veterinarian_id integer,
    pet_id integer,
    primary key (examination_id)
) engine=InnoDB;

create table pet (
    id integer not null auto_increment,
    age integer,
    approval_status tinyint check (approval_status between 0 and 3),
    image_path varchar(255),
    name varchar(30) not null,
    sex varchar(10) not null,
    species varchar(20) not null,
    shelter_id integer,
    citizen_id integer,
    primary key (id)
) engine=InnoDB;

create table roles (
    id integer not null auto_increment,
    name varchar(255) not null,
    primary key (id)
) engine=InnoDB;

create table shelter (
    address varchar(30) not null,
    approval_status tinyint check (approval_status between 0 and 3),
    description varchar(200),
    location varchar(20) not null,
    name varchar(30) not null,
    id integer not null,
    primary key (id)
) engine=InnoDB;

create table user_roles (
    user_id integer not null,
    role_id integer not null,
    primary key (user_id, role_id)
) engine=InnoDB;

create table users (
    id integer not null auto_increment,
    email varchar(50) not null,
    password varchar(255) not null,
    phone varchar(15) not null,
    username varchar(20) not null,
    primary key (id)
) engine=InnoDB;

create table veterinarian (
    first_name varchar(30) not null,
    last_name varchar(30) not null,
    id integer not null,
    primary key (id)
) engine=InnoDB;

alter table citizen add constraint UKq131jyycc9ee6gqv85t68v3kx unique (first_name);
alter table citizen add constraint UKr3xx9lqa4cm4tw9wel8gbei8p unique (last_name);
alter table users add constraint UKr43af9ap4edm43mmtq01oddj6 unique (username);
alter table users add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);
alter table veterinarian add constraint UK1c1q5s0stb2h544r3leohmdq2 unique (first_name);
alter table veterinarian add constraint UKakuxthhs0xj8k4th3a8or9fyd unique (last_name);

alter table adoption add constraint FK524ve83h4q3vgrpcarjlfqqfh foreign key (citizen_id) references citizen (id);
alter table adoption add constraint FK3oe17ipty7m7fevf3a7w3s8aj foreign key (shelter_id) references shelter (id);
alter table adoption add constraint FK1v07h6n52dn0s7rfppgr4tspy foreign key (pet_id) references pet (id);
alter table citizen add constraint FKkai25xx449cjccv8bheqwxwob foreign key (id) references users (id);
alter table contact add constraint FKqgw82dufqus2udga2rxuywrye foreign key (citizen_id) references citizen (id);
alter table contact add constraint FKid2qvl69up65d06cyrdx1fog8 foreign key (shelter_id) references shelter (id);
alter table health_check add constraint FKn3922p4s30m57k8ibrxgc9we8 foreign key (veterinarian_id) references veterinarian (id);
alter table health_check add constraint FK8nelrrp9gi5w9ka5sh9vmwwms foreign key (pet_id) references pet (id);
alter table pet add constraint FKdujrkamkv5tvd3sgqkpu7mwsi foreign key (shelter_id) references shelter (id);
alter table pet add constraint FKjhf54sbsyw3t4tecoec4m2a2c foreign key (citizen_id) references citizen (id);
alter table shelter add constraint FKqi4i2l6ml5tx4yyfkutrnnvih foreign key (id) references users (id);
alter table user_roles add constraint FKh8ciramu9cc9q3qcqiv4ue8a6 foreign key (role_id) references roles (id);
alter table user_roles add constraint FKhfh9dx7w3ubf1co1vdev94g3f foreign key (user_id) references users (id);
alter table veterinarian add constraint FKs04bhhic2vp0h6sbbamdno6wu foreign key (id) references users (id);