import time
import sys
import psycopg2

def insert_data(pg_hosts):
    '''
    We assume the first element in pg_hosts is the primary instance.
    We also assume that pg_hosts is a list of two hosts.
    Each host is a tuple of type (host, port).

    Keep inserting the current timestamp into the apptable,
    until you hit an error. Once error is hit for 5 consecutive times, 
    try to use the remaining host to connect and continue the insertion.
    If the new host also fails for 5 consecutive times, abort the app
    '''
    tries = 0
    current_host = pg_hosts[0]
    while(True):
        try:
            print(f"Connecting app to host {current_host[0]} port {current_host[1]}...")
            connection = psycopg2.connect(
                host=current_host[0], 
                database='appdata', 
                user='appuser', 
                password='welcome',
                port=current_host[1])

            # Make sure to commit after each statement
            connection.autocommit = True
            cur = connection.cursor()

            # Insert current timestamp
            cur.execute("insert into apptable values(now());")
            print("Inserted timestamp into apptable")

            # Get the count for a simple validation. This should keep increasing
            cur.execute("select count(*) from apptable")
            results = cur.fetchall()[0][0]
            print(f"Current number of rows: {results}")

            cur.close()
            connection.close()
            time.sleep(1)
            tries = 0
        except Exception as e:
            print(e)
            tries+=1
            if tries == 5:
                # Remove this host from the host list and try with another host.
                old_host = current_host
                pg_hosts.remove(old_host)
                
                # If no host left to try, then abort.
                if not pg_hosts:
                    print("Exhausted all retries with all hosts. Aborting the app!")
                    sys.exit(1)
                
                # Continue with another host
                current_host = PG_HOSTS[0]
                print(f"Insert attempt with host {old_host} failed {tries} times. " + \
                        f"Going to try with {current_host} host after 5 seconds")
                tries = 0
                time.sleep(5)
                continue
            time.sleep(1)

 
if __name__ == "__main__":
    PG_HOSTS = [('localhost','5433'),('localhost', '5434')]
    print("Starting the app...")
    insert_data(PG_HOSTS)



