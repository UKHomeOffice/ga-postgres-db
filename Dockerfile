FROM quay.io/ukhomeofficedigital/centos-base:v0.5.5

# BP: BASE PATH
ENV PG_BP /u01/pgsql

# BPV: BASE PATH WITH VERSION
ENV PG_BPV $PG_BP/9.6

# PATH: Full Path
ENV PG_PATH $PG_BPV/data

ENV PG_ETC /etc/postgresql

ENV PG_LOG /var/log/postgresql

# PS: Postgres user
ENV PG_SU postgres

# DB: Ga Database
ENV PG_PS postgres

# CFG: Postgres Sys Config File
ENV PG_CFG /etc/sysconfig/pgsql/postgresql-9.6

# FW_BP: Flyway Base Path
ENV FW_BP /u01/flyway

# FW_V: Flyway Version
ENV FW_V 4.1.2

# PATH: Flyway Path to the installation folder
ENV FW_PATH $FW_BP/flyway-$FW_V

# EX: Flyway executable absolute path
ENV FW_EX $FW_PATH/flyway

# postgres controller
ENV PG_CTL /usr/pgsql-9.6/bin/pg_ctl

#Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["$PG_PATH", "$PG_ETC", "$PG_LOG", "$PG_BP"]

# Download and install RPM for postgres 9.6
RUN rpm -i https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-6-x86_64/pgdg-centos96-9.6-3.noarch.rpm
RUN yum install postgresql96-server postgresql96-contrib -y
RUN mkdir $PG_PATH -p \
  && mkdir $PG_ETC -p \
  && mkdir $PG_LOG -p \
  && chown -R $PG_SU:$PG_SU $PG_PATH \
  && chown -R $PG_SU:$PG_SU $PG_BP \
  && chown -R $PG_SU:$PG_SU $PG_ETC \
  && chown -R $PG_SU:$PG_SU $PG_LOG \
  && su - postgres -c "$PG_CTL init -D $PG_PATH -o '-E UTF8 --locale en_GB.UTF-8'"\
  && su postgres \
      && echo "listen_addresses='*'" >> $PG_PATH/postgresql.conf \
      && echo "host    all             all             all            trust" >> $PG_PATH/pg_hba.conf \
      && echo "host    all             all             0.0.0.0/0               trust" >> $PG_PATH/pg_hba.conf \
      && echo "host    all             all             172.18.0.0/16           trust" >> $PG_PATH/pg_hba.conf \
      && echo "host    all             all             ::/0               trust" >> $PG_PATH/pg_hba.conf

# Flag for new db
RUN touch $PG_PATH/new.db

## Installing & Setting up Flyway
RUN yum install java -y
RUN mkdir /u01/flyway -p
RUN curl -o $FW_BP/flyway.tar.gz http://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/$FW_V/flyway-commandline-$FW_V.tar.gz
RUN cd $FW_BP && tar -xzvf flyway.tar.gz
RUN ln -s -T $FW_EX /usr/bin/flyway && chmod 755 $FW_EX

# Expose port 5432
EXPOSE 5432
