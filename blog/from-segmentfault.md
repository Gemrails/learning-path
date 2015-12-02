# �¼��㲥

## ���
Laravel 5.1 ֮���¼������¼��㲥�Ĺ��ܣ������ǰѷ������д������¼�ͨ��websocket����֪ͨ�ͻ��ˣ�Ҳ������������ͻ���js���ݽ��ܵ����¼���������Ӧ���������Ļ��ü򵥵Ĵ���չʾһ���¼��㲥�Ĺ��̡�

## ����
- redis
- nodejs, socket.io
- laravel 5.1

## ����
`config/broadcasting.php`�У���������`'default' => env('BROADCAST_DRIVER', 'redis'),`��ʹ��redis��Ϊphp��js��ͨ�ŷ�ʽ��
`config/database.php`������redis�����ӡ�

## ����һ�����㲥���¼�
����Laravel�ĵ���˵���������¼����㲥��������`Event`��ʵ��һ��`Illuminate\Contracts\Broadcasting\ShouldBroadcast`�ӿڣ�����ʵ��һ������`broadcastOn`��`broadcastOn`����һ�����飬�������¼����͵���`channel`(Ƶ��)�����£�

    namespace App\Events;
    
    use App\Events\Event;
    use Illuminate\Queue\SerializesModels;
    use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
    
    class SomeEvent extends Event implements ShouldBroadcast
    {
        use SerializesModels;
    
        public $user_id;
    
        /**
         * Create a new event instance.
         *
         * @return void
         */
        public function __construct($user_id)
        {
            $this->user_id = $user_id;
        }
    
        /**
         * Get the channels the event should be broadcast on.
         *
         * @return array
         */
        public function broadcastOn()
        {
            return ['test-channel'];
        }
    }
    
## ���㲥������
Ĭ������£�`Event`�е�����public���Զ��ᱻ���л���㲥������������о���`$user_id`������ԡ���Ҳ����ʹ��`broadcastWith`�����������ȷ��ָ��Ҫ�㲥ʲô���ݡ����磺

    public function broadcastWith()
    {
        return ['user_id' => $this->user_id];
    }

## Redis��Websocket������
- ��Ҫ����һ��Redis���¼��㲥��Ҫ�����ľ���redis��sub/pub���ܣ�������Կ�redis�ĵ�

- ��Ҫ����һ��websocket����������clientͨ�ţ�����ʹ��socket.io����������:

        var app = require('http').createServer(handler);
        var io = require('socket.io')(app);
        
        var Redis = require('ioredis');
        var redis = new Redis('6379', '192.168.1.106');
        
        app.listen(6001, function() {
            console.log('Server is running!');
        });
        
        function handler(req, res) {
            res.writeHead(200);
            res.end('');
        }
        
        io.on('connection', function(socket) {
            console.log('connected');
        });
        
        redis.psubscribe('*', function(err, count) {
            console.log(count);
        });
        
        redis.on('pmessage', function(subscribed, channel, message) {
            console.log(subscribed);
            console.log(channel);
            console.log(message);
        
            message = JSON.parse(message);
            io.emit(channel + ':' + message.event, message.data);
        });
    
������Ҫע�����`redis.on`�����Ķ���,���յ���Ϣ�󣬸�client����һ���¼����¼�����Ϊ`channel + ':' + message.event`��

## �ͻ��˴���
�ͻ�������Ҳʹ��socket.io����Ϊ���ԣ����뾡���򻯣�������ӡһ�����ܵ������ݼ��ɡ����£�

    var socket = io('http://localhost:6001');
    socket.on('connection', function (data) {
        console.log(data);
    });
    socket.on('test-channel:App\\Events\\SomeEvent', function(message){
        console.log(message);
    });
    console.log(socket);
    
## �����������¼�
ֱ����router�ж�����¼��������ɡ����£�

    Route::get('/event', function(){
        Event::fire(new \App\Events\SomeEvent(3));
        return "hello world";
    });
    
## ����
- ����redis
- ����websocket
- �򿪴��пͻ��˴����ҳ�棬���Կ���websocket�Ѿ����ӳɹ���
- �����¼�,����һ��ҳ�� `localhost/event`��

��ʱ�Ϳ��Է��֣���һ��ҳ���console�д�ӡ����`Object{user_id: 3}`��˵���㲥�ɹ���

��¼��һ��[��ѧ��Ƶ](http://v.youku.com/v_show/id_XMTI2MzMwMTIzMg==.html)��������в����׿��Բο������Ƶ��
































> ��Ϊ�����ѧϰGo����������revel��������ѧϰ���о���php����������кܴ�ͬ��revelû���ṩdb mapping�������������github�����˺ܶ�ORM��ѧϰ����`jmoiron/sqlx`�з�����һƪ�Ƚ���ϸ����`database/sql`����������£������ʹ�ҷ������Ĳ����ǰ��־�ķ��룬��������������������Ķ�ԭ�� [ԭ�ĵ�ַ](http://go-database-sql.org/index.html)

## ����

`sql.DB`����һ�����ӣ��������ݿ�ĳ���ӿڡ������Ը���driver�򿪹ر����ݿ����ӣ��������ӳء�����ʹ�õ����ӱ����Ϊ��æ�������ص����ӳصȴ��´�ʹ�á����ԣ������û�а������ͷŻ����ӳأ��ᵼ�¹�������ʹϵͳ��Դ�ľ���

## ʹ��DB

### ����driver
����ʹ�õ���[MySQL drivers](https://github.com/go-sql-driver/mysql)
```
import (
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
)
```

### ����DB

```
func main() {
	db, err := sql.Open("mysql",
		"user:password@tcp(127.0.0.1:3306)/hello")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
}
```

`sql.Open`�ĵ�һ��������driver���ƣ��ڶ���������driver�������ݿ����Ϣ������driver���ܲ�ͬ��DB�������ӣ�����ֻ�е���Ҫʹ��ʱ�Żᴴ�����ӣ������������֤���ӣ���Ҫ��`Ping()`���������£�
```
err = db.Ping()
if err != nil {
	// do something here
}
```
sql.DB����ƾ���������Ϊ������ʹ�õġ���ҪƵ��Open, Close���ȽϺõ������ǣ�Ϊÿ����ͬ��datastore��һ��DB���󣬱�����Щ����Open�������Ҫ�����ӣ���ô��DB��Ϊ��������function������Ҫ��function��Open, Close��

### ��ȡDB
�����������`Query`����ô������������ڲ�ѯ������rows�ġ��������Ӧ����`Exec()`��
```
var (
	id int
	name string
)
rows, err := db.Query("select id, name from users where id = ?", 1)
if err != nil {
	log.Fatal(err)
}
defer rows.Close()
for rows.Next() {
	err := rows.Scan(&id, &name)
	if err != nil {
		log.Fatal(err)
	}
	log.Println(id, name)
}
err = rows.Err()
if err != nil {
	log.Fatal(err)
}
```

�������Ĺ���Ϊ��`db.Query()`��ʾ�����ݿⷢ��һ��query��`defer rows.Close()`�ǳ���Ҫ������rowsʹ��`rows.Next()`�� �ѱ����������ݴ������ʹ��`rows.Scan()`, ������ɺ���error���м�����Ҫע�⣺

1. �������Ƿ���error
2. �����(rows)δ�ر�ǰ���ײ�����Ӵ��ڷ�æ״̬���������������һ����¼ʱ���ᷢ��һ���ڲ�EOF�����Զ�����`rows.Close()`�����������ǰ�˳�ѭ����rows����رգ����Ӳ���ص����ӳ��У�����Ҳ����رա������ֶ��رշǳ���Ҫ��`rows.Close()`���Զ�ε��ã����޺�������

### ����Query

err��`Scan`��Ų��������Կ�������д��
```
var name string
err = db.QueryRow("select name from users where id = ?", 1).Scan(&name)
if err != nil {
	log.Fatal(err)
}
fmt.Println(name)
```

## �޸����ݣ�����

һ����Prepared Statements��`Exec()`���`INSERT`, `UPDATE`, `DELETE`������
```
stmt, err := db.Prepare("INSERT INTO users(name) VALUES(?)")
if err != nil {
	log.Fatal(err)
}
res, err := stmt.Exec("Dolly")
if err != nil {
	log.Fatal(err)
}
lastId, err := res.LastInsertId()
if err != nil {
	log.Fatal(err)
}
rowCnt, err := res.RowsAffected()
if err != nil {
	log.Fatal(err)
}
log.Printf("ID = %d, affected = %d\n", lastId, rowCnt)
```

### ����

`db.Begin()`��ʼ����`Commit()` �� `Rollback()`�ر�����`Tx`�����ӳ���ȡ��һ�����ӣ��ڹر�֮ǰ����ʹ��������ӡ�Tx���ܺ�DB���`BEGIN`, `COMMIT`���ʹ�á�

�������Ҫͨ����������޸�����״̬�������ʹ��Tx�����磺

- �������Ե������ӿɼ�����ʱ��
- ���ñ���������`SET @var := somevalue`
- �ı�����ѡ������ַ�������ʱ


## Prepared Statements

### Prepared Statements and Connection

�����ݿ���棬Prepared Statements�Ǻ͵������ݿ����Ӱ󶨵ġ��ͻ��˷���һ����ռλ����statement������ˣ�����������һ��statement ID��Ȼ��ͻ��˷���ID�Ͳ�����ִ��statement��

��GO�У����Ӳ�ֱ�ӱ�¶���㲻��Ϊ���Ӱ�statement������ֻ��ΪDB��Tx�󶨡�`database/sql`�����Զ����Եȹ��ܡ���������һ��Prepared Statement

1. �Զ������ӳ��а󶨵�һ����������
2. `Stmt`�����ס�����ĸ�����
3. ִ��`Stmt`ʱ������ʹ�ø����ӡ���������ã��������ӱ��رջ�æ�У����Զ�re-prepare���󶨵���һ�����ӡ�

��͵����ڸ߲����ĳ���������ʹ��statement���ܵ���statementй©��statement�����ظ�prepare��re-prepare�Ĺ��̣�������ﵽ��������statement�������ޡ�

ĳЩ����ʹ����PS������`db.Query(sql, param1, param2)`, ��������Զ��ر�statement��

��Щ�������ʺ���statement��

1. ���ݿⲻ֧�֡�����Sphinx��MemSQL������֧��MySQL wire protocol, ����֧��"binary" protocol��
2. statement����Ҫ���úܶ�Σ�����������������֤��ȫ��[����](https://vividcortex.com/blog/2014/11/19/analyzing-prepared-statement-performance-with-vividcortex/)


### ��Transaction��ʹ��PS

PS��Tx��Ψһ��һ�����ӣ�����re-prepare��

Tx��statement���ܷ��룬��DB�д�����statementҲ������Tx��ʹ�ã���Ϊ���Ǳض�����ʹ��ͬһ������ʹ��Tx����ʮ��С�ģ���������Ĵ��룺
```
tx, err := db.Begin()
if err != nil {
	log.Fatal(err)
}
defer tx.Rollback()
stmt, err := tx.Prepare("INSERT INTO foo VALUES (?)")
if err != nil {
	log.Fatal(err)
}
defer stmt.Close() // danger!
for i := 0; i < 10; i++ {
	_, err = stmt.Exec(i)
	if err != nil {
		log.Fatal(err)
	}
}
err = tx.Commit()
if err != nil {
	log.Fatal(err)
}
// stmt.Close() runs here!
```
`*sql.Tx`һ���ͷţ����Ӿͻص����ӳ��У�����stmt�ڹر�ʱ���޷��ҵ����ӡ����Ա�����Tx commit��rollback֮ǰ�ر�statement��


## ����Error

### ѭ��Rows��Error
���ѭ���з���������Զ�����`rows.Close()`����`rows.Err()`�����������Close�������Զ�ε��á�ѭ��֮���ж�error�Ƿǳ���Ҫ�ġ�
```
for rows.Next() {
	// ...
}
if err = rows.Err(); err != nil {
	// handle the error here
}
```

### �ر�Resultsetsʱ��error
�������rows��������֮ǰ�˳�ѭ���������ֶ��ر�Resultset�����ҽ���error��
```
for rows.Next() {
	// ...
	break; // whoops, rows is not closed! memory leak...
}
// do the usual "if err = rows.Err()" [omitted here]...
// it's always safe to [re?]close here:
if err = rows.Close(); err != nil {
	// but what should we do if there's an error?
	log.Println(err)
}
```

### QueryRow()��error

```
var name string
err = db.QueryRow("select name from users where id = ?", 1).Scan(&name)
if err != nil {
	log.Fatal(err)
}
fmt.Println(name)
```
���idΪ1�Ĳ����ڣ�errΪsql.ErrNoRows��һ��Ӧ���в����ڵ��������Ҫ�����������⣬Query���صĴ��󶼻��ӳٵ�Scan�����ã�����Ӧ��д�����´��룺
```
var name string
err = db.QueryRow("select name from users where id = ?", 1).Scan(&name)
if err != nil {
	if err == sql.ErrNoRows {
		// there were no rows, but otherwise no error occurred
	} else {
		log.Fatal(err)
	}
}
fmt.Println(name)
```
�ѿս������Error������Ϊ��ǿ���ó���Ա������Ϊ�յ����


### �������ݿ�Error

�������ݿ⴦��ʽ��̫һ����mysqlΪ����
```
if driverErr, ok := err.(*mysql.MySQLError); ok { 
	// Now the error number is accessible directly
	if driverErr.Number == 1045 {
		// Handle the permission-denied error
	}
}
```
`MySQLError`, `Number`����DB����ģ�������ݿ�����Ǳ�����ͻ��ֶΡ���������ֿ����滻Ϊ��������������� [MySQL error numbers maintained by VividCortex](https://github.com/VividCortex/mysqlerr)

### ���Ӵ���

## NULLֵ����

��˵����������ݿ��ʱ��Ҫ����null�����������ǳ�������Null��type�����ޣ�����û��`sql.NullUint64`; nullֵû��Ĭ����ֵ��
```
for rows.Next() {
	var s sql.NullString
	err := rows.Scan(&s)
	// check err
	if s.Valid {
	   // use s.String
	} else {
	   // NULL value
	}
}
```

## δ֪Column

`rows.Columns()`��ʹ�ã����ڴ����ܵ�֪����ֶθ��������͵���������磺
```
cols, err := rows.Columns()
if err != nil {
	// handle the error
} else {
	dest := []interface{}{ // Standard MySQL columns
		new(uint64), // id
		new(string), // host
		new(string), // user
		new(string), // db
		new(string), // command
		new(uint32), // time
		new(string), // state
		new(string), // info
	}
	if len(cols) == 11 {
		// Percona Server
	} else if len(cols) > 8 {
		// Handle this case
	}
	err = rows.Scan(dest...)
	// Work with the values in dest
}
```

```
cols, err := rows.Columns() // Remember to check err afterwards
vals := make([]interface{}, len(cols))
for i, _ := range cols {
	vals[i] = new(sql.RawBytes)
}
for rows.Next() {
	err = rows.Scan(vals...)
	// Now you can check each element of vals for nil-ness,
	// and you can use type introspection and type assertions
	// to fetch the column into a typed variable.
}
```

## �������ӳ�

1. ����������������LOCK TABLE���� INSERT����������Ϊ������������ͬһ�����ӣ�insert������û��table lock��
2. ����Ҫ���ӣ������ӳ���û�п�������ʱ���µ����Ӿͻᱻ������
3. Ĭ��û���������ޣ����������һ����������ܻᵼ�����ݿ��������too many connections��
4. `db.SetMaxIdleConns(N)`����������������
5. `db.SetMaxOpenConns(N)`��������������
6. ��ʱ�䱣�ֿ������ӿ��ܻᵼ��db timeout


























> ����˵Ŀ����벻��Э�飬swoole�ĳ��ֶ���ѧϰͨ����˵�������Ƿǳ��õĽ̲ġ��ǳ��Ƽ�������� [Swoole Framework](https://github.com/swoole/framework)�����а����˶���Э���phpʵ�֣�����FTP��HTTP��Websocket�ȡ����Ĵ󲿷ִ��붼���������Ŀ����������Ȼѧϰ��ͬʱ������starһ�������Ŀ�����߱�����������������д��ƪ���µ�ͬʱҲ���˲������ϣ�����д���ӭ���������

## websocketЭ��ѧϰ

### ����
Э���Ϊ�����֣����֣����ݴ���

�ͻ��˷�����������Ϣ���ƣ�

```
GET /chat HTTP/1.1
Host: server.example.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Origin: http://example.com
Sec-WebSocket-Protocol: chat, superchat
Sec-WebSocket-Version: 13
```

���������ص�������Ϣ���ƣ�

```
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
Sec-WebSocket-Protocol: chat
Sec-WebSocket-Version: 13
```

������Ϣ�ĵ�һ�д��Ӧ�ö��Ƚ���Ϥ����HTTPЭ���е�Request-Line��Status-Line��[RFC2616](https://tools.ietf.org/html/rfc2616)��������ų��ֵ��������ͷ��Ϣ�����HTTPЭ����ͬ�� һ�����ֳɹ���һ��˫������ͨ���ͽ����ˡ�
�������ڴ���`message`, `message`��һ������`frame`��ɡ�ÿ��frame��һ�����ͣ�����ͬһ��message��frame�����Ͷ���ͬ�����Ͱ������ı��������ƣ�control frame(Э����ź�)�ȡ�Ŀǰһ����6�����ͣ�10�ֱ������͡�

### ����

��������Ŀͻ���ͷ��Ϣ���Կ��������ֺ�HTTP�Ǽ��ݵġ�WS��������HTTP��"�����汾"��

�ͻ��˷��͵������������
1. ��һ���Ϸ���HTTP����
2. ������GET
3. ͷ�������HOST�ֶ�
4. ͷ�������Upgrade�ֶΣ�ֵΪwebsocket,���Կ������ж�����Ϊws�ı�־��
5. ͷ�������Connection�ֶΣ�ֵΪUpgrade��
6. ͷ�������Sec-WebSocket-Key�ֶΣ�������֤��
7. ������������������ͷ������� Origin�ֶΡ�
8. ͷ�������Sec-WebSocket-Version�ֶΣ�ֵΪ13

### ��֤����

ȡ`Sec-WebSocket-Key `�ֶε�ֵ������һ��GUID�ַ���,"258EAFA5-E914-47DA-95CA-C5AB0DC85B11", sha1 hashһ�£���base64_encode���õ���ֵ��Ϊ�ֶ�`Sec-WebSocket-Accept`��ֵ���ظ��ͻ��ˡ���php�����ʾ:

```
'Sec-WebSocket-Accept' => base64_encode(sha1($key . static::GUID, true))
```

ͬʱ�����ص�״̬����Ϊ101������״̬����ʾ����û�гɹ��� `Connection`,`Upgrade`�ֶ���ΪHTTP�����������ڡ�һ�����ַ������£�

```
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
```

### Frame(֡)�Ľṹ���£�
```
  0                   1                   2                   3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-------+-+-------------+-------------------------------+
 |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
 |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
 |N|V|V|V|       |S|             |   (if payload len==126/127)   |
 | |1|2|3|       |K|             |                               |
 +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
 |     Extended payload length continued, if payload len == 127  |
 + - - - - - - - - - - - - - - - +-------------------------------+
 |                               |Masking-key, if MASK set to 1  |
 +-------------------------------+-------------------------------+
 | Masking-key (continued)       |          Payload Data         |
 +-------------------------------- - - - - - - - - - - - - - - - +
 :                     Payload Data continued ...                :
 + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
 |                     Payload Data continued ...                |
 +---------------------------------------------------------------+
```

- `FIN`: 1 bit, ����Ƿ������һ��message�����һ��Ƭ��
- `RSV1`, `RSV2`, `RSV3`�� �� 1 bit, ������ǣ���Ϊ0
- `Opcode`��4 bits�� �Ƕ�payload data��˵����ָ�����֡�����͡�
1. 0x0 ����Ϊ������һ֡������֡
2. 0x1 ����Ϊtext frame
3. 0x2 ����Ϊbinary frame
4. 0x3-7 ����
5. 0x8 ��ʾ���ӹر�
6. 0x9 Ϊping
7. 0xA Ϊpong
8. 0xB-F ���� 
- `Mask`: 1 bit, ָ��Payload data�Ƿ�mask�����Ϊ1����ô������Ҫ����masking-key��unmask���ͻ��˷��͵�֡����mask�ġ�
- `Payload length`�� 7 bits �� 7+16 bits �� 7+64 bits. ���ֵΪ0-125����ô��ֵ����payload�ĳ��ȣ����Ϊ126����ô��������2��byte��ʾpayload����(16bit, unsigned)�� ���Ϊ127����ô��������8��bytes��ʾpayload�ĳ���(64bit, unsigned)��
- `Masking-key`: 0 �� 4 bytes, ����unmask payload data��
- `Payload data`: ����Ϊ Payload length, ���Է�Ϊ extension data + application data, ��չ���ݵĳ��ȼ��㷽��������������õģ�ʣ��ľ���Ӧ�����ݡ�
 
### Mask����

`masking-key`�ǿͻ�������ָ����32bit����ֵ����ԭʼ���ݵ�masked���ݵķ�ʽΪ��`ԭʼ���ݵ�i���ֽڵ�ֵ XOR masking-key�ĵ�(i%4)���ֽڵ�ֵ`��XOR��ʾ���%��ʾȡģ��


### Ƭ�λ�������

������һ��δ֪���ȵ�����ʱ�����Բ���һ����bufferȫ�������ݡ����䵱���ݷǳ���ʱ�����Էֶ��buffer����װΪframe�����͡�

### ���Խ���һ��frame

������������Ѿ��˽���frame�Ľṹ���Ƿ��볢�Խ���һ��frame���ٷ��ĵ��ṩ�˼���[����������](https://tools.ietf.org/html/rfc6455#page-38)�����ǿ���������ϰһ�¡�����ѡ����������, �������£�

```php
<?php

//A single-frame unmasked text message
$data = array(0x81, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6f);
//A single-frame masked text message
$data2 = array(0x81, 0x85, 0x37, 0xfa, 0x21, 0x3d, 0x7f, 0x9f, 0x4d, 0x51, 0x58);


handleData(toString($data));
handleData(toString($data2));

function toString(array $data) {
    return array_reduce($data, function($carry, $item){
        return $carry .= chr($item);
    });
}

function handleData($data){
	$offset = 0;

	$temp = ord($data[$offset++]);
	$FIN = ($temp >> 7) & 0x1;
	$RSV1 = ($temp >> 6) & 0x1;
	$RSV2 = ($temp >> 5) & 0x1;
	$RSV3 = ($temp >> 4) & 0x1;
	$opcode = $temp & 0xf;

	echo "First byte: FIN is $FIN, RSV1-3 are $RSV1, $RSV2, $RSV3; Opcode is $opcode \n";

	$temp = ord($data[$offset++]);
	$mask = ($temp >> 7) & 0x1;
	$payload_length = $temp & 0x7f;
	if($payload_length == 126){
		$temp = substr($data, $offset, 2);
		$offset += 2;
		$temp = unpack('nl', $temp);
		$payload_length = $temp['l'];
	}elseif($payload_length == 127){
		$temp = substr($data, $offset, 8);
		$offset += 8;
		$temp = unpack('nl', $temp);
		$payload_length = $temp['l'];
	}
	echo "mask is $mask, payload_length is $payload_length \n";

	if($mask ==0){
		$temp = substr($data, $offset);
		$content = '';
        for ($i=0; $i < $payload_length; $i++) { 
            $content .= $temp[$i];
        }
	}else{
		$masking_key = substr($data, $offset, 4);
		$offset += 4;
		
		$temp = substr($data, $offset);
		$content = '';
        for ($i=0; $i < $payload_length; $i++) { 
            $content .= chr(ord($temp[$i]) ^ ord($masking_key[$i%4]));
        }
	}

	echo "content is $content \n";
}
```
����������ͼ��

![output result][1]

> ��������ʵ�������꣬wsЭ�黹�кܶ�ܶ����RFC�ĵ�ʵ����̫���ˡ����磬���Ӧ��ÿһ��control frame������ϸ��˵������ιر����ӣ�Э����չ����������ȫ��أ�һЩ���������ݶ�����swoole framework���ҵ���Ӧ�Ĵ��롣


  [1]: /img/bVm1yL
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  > �����Ҫ��Instagram��apiץȡ���û���ͼƬ��������Ҫ��oauth2��֤, ����Ӧ�ñ������һ��web���档�����ܹ�ʵʱ��������������������websocket��������Ҫ���ǵ�Ч�����⣬�ۺ����ϼ��㣬����һ�����Կ����Ļ�������ѡ����golang���п�����node�Ļص�ʵ�ڲ�ϲ����

## ǰ��

����golang��web�����в��ٿ�ܣ����� martini, gin, revel��gorilla�ȡ� ֮ǰ���`revel`���о���װ��̫���ˣ���Ϊһ��СӦ�ò���Ҫ��ô���ӣ�����google�õ������revel��Ч����Խϲ`gin`��benchmark��ʾЧ����martini��40��������gin�Ƚ����������ĵ���̬Ȧ��Խ��١�����ѡ����`martini`, �кܶ�middleware����ѡ�����оͰ�����websocket�����ұ����õ���gorilla websocket�������

## ����͹���

1. һ����ת��Oauth2��½��Ȩҳ�������
2. ��Ȩ��ɺ����ط����ҳ�棬��ʱ�����access_token, �Ϳ���Ϊ����Ϊ�ˡ�ȫ���Ĺ���Ҳ�����������ҳ�棬���յĽ�������ͼ��ʾ��

![����͹���][1]


`�������`��������websocket���ӵġ�`��ʼ��������`�ǿ�ʼ���û�ID��������ˣ�����˵���api��ʼץȡͼƬ��`ֹͣ`����ֹͣ���ε�ץȡ����`���������`����ʵʱ����ץȡ��ͼƬ������


## ������½ṹ

![������½ṹ][2]

�����`Jobs`, `goroutine #1`, `#2`��������ȫ����Ϊ����websocket�Ͽ������ػ��ܼ���ִ�С�`websocket goroutine`�����ӽ���������������ӶϿ������goroutine�Ͳ������ˡ�`Jobs`, `NextUrl`�䵱���еĽ�ɫ�� `Done`�����ý����Ǽ�����������д������ȫ�ֱ�����`Quit chan int`, `IsPreparing bool`, ������������������ǰ�˿���ץȡ�����Ƿ���еġ�

��������һ�����������forѭ����һ�����������forѭ����һ�����ڸ�client���ؼ�����forѭ�������ﲻ�ò���̾��goroutine channel�����ʹ�ñ�������ˡ�

## ����������
���ڵ�һ������ʹ��Go������������������ġ���������Ƚϼ򵥣�����û�нӴ�ʲô��������ݡ���Ҫ������ǿ���ʹ��������⡣

### DB��ѯ
֮ǰд��һƪ����[database/sql](http://segmentfault.com/a/1190000003036452)�����£����ֱ������`sqlx`����⣬������д���ٴ��룬Ҳ�ٷ����󡣵��ǱϾ�����laravel��ô���㣬������Ҫд��sql���࣬��ʱд���������͸㶨��ͬʱ˼�������ʵ��һ��eloquent��api��ò�����Ѷȡ�

### Json����
ǿ���;�����Json�Ĵ����Ǹ�ʹ��֮ǰд��һ������Ԥ����С�����õ���`map[string]*json.RawMessage` ����ӳ��ṹ��Ȼ��һ��һ��⿪json����ʱû��������������ģ���Ϊ�����`RawMessage`, �ַ���������`"`Ҳ�ᱻ������ʹ���ַ������ǰ��������š�
����ٴ�google��һ�Σ����ֻ��ǵ���`map[string]interface{}`��ӳ�䣬Ȼ������`type assertion`��һ���Ľ⿪json������һ��ʹ��Ĺ��̣�����php�е�`json_decode()`�����������档

### Stop Goroutine
����ж�һ��goroutine��һ�����⣬��Ϊ��Ҫ���ƿ�ʼֹͣ���ȸ�һ�ºܿ���н����
```golang
    go func() {
		for {
			select {
			case <-Quit:
				IsPreparingJobs = false
				return
			default:
			    // to do something
			}

		}
	}()
```
��������һ��`IsPreparingJobs`�������жϺ��ٴο�ʼ���ѭ����

### Testing
Golang�ṩ�Ĳ��Թ��߷ǳ����㣬`go test`���ܽ������в��ԡ���martiniԴ���и������������÷���������
```golang
func expect(t *testing.T, a interface{}, b interface{}) {
	if a != b {
		t.Errorf("Expected %v (type %v) - Got %v (type %v)", b, reflect.TypeOf(b), a, reflect.TypeOf(a))
	}
}

func refute(t *testing.T, a interface{}, b interface{}) {
	if a == b {
		t.Errorf("Did not expect %v (type %v) - Got %v (type %v)", b, reflect.TypeOf(b), a, reflect.TypeOf(a))
	}
}
```

## �ܽ�
�о�golang��Ϊweb�������ߣ������ݸ�ʽ�����棬û�����������Է��㡣���node���Ƿǳ��ã�jsonתobject�ǳ����㡣Ҳ�����Promise��node��ȽϺ��ðɡ�golangҲ�����ƣ�goroutine�ǳ����ã��ٷ��Ŀ⹦�ܷǳ�ȫ�����Ϊ�����ƿ�ִ���ļ�ʹ�ò����쳣���ף�ǿ��������Ч�ʱȽϸߡ�

����и���ǰ�����shadowsockets�¼�����Ϊһ��ssʹ���ߣ����˸�л��˽�Ŀ����ߣ�ʣ�µľ�ֻ�Ƿ�ŭ��ʧ���������ֿ������޵�T1�����ᣬ`Born to be proud`, `��������`���ڼ������ԭ���棬����һֱ���ҵĿ�ģ���ڴ�����Ĵ��ӷ����ᡣ


  [1]: /img/bVoOko
  [2]: /img/bVoOas
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  > Laravel5ʵ���û��ѺõĴ���ҳ��ǳ��򵥣�������Ҫ����status 404��ֻ��Ҫ��`view/errors`�����һ��`404.blade.php`�ļ����ɡ�Lumen��û��Ĭ��ʵ�����ֱ����������Լ����һ����

# Lumen���ʵ����Laravel5�û��ѺõĴ���ҳ��

## ԭ��

�׳�����ĺ�����`abort()`, ����ú���һ���������ᷢ��ֻ���׳�һ��`HttpException`. ��Application�У�����http request��ʱ����һ��try catch�Ĺ��̣�Exception���������ﱻ����ġ�

```php
try {
    return $this->sendThroughPipeline($this->middleware, function () use ($method, $pathInfo) {
        if (isset($this->routes[$method.$pathInfo])) {
            return $this->handleFoundRoute([true, $this->routes[$method.$pathInfo]['action'], []]);
        }

        return $this->handleDispatcherResponse(
            $this->createDispatcher()->dispatch($method, $pathInfo)
        );
    });
} catch (Exception $e) {
    return $this->sendExceptionToHandler($e);
}
```

���ſ��Կ�����Exception�ǽ�����`sendExceptionToHandler`ȥ�����ˡ������handler�������ĸ����أ���ʵ����`Illuminate\Contracts\Debug\ExceptionHandler`��һ��������Ϊɶ˵���ǵ�������Ϊ��bootstrap��ʱ���Ѿ���ʼ��Ϊ�����ˣ��뿴��

```php
$app->singleton(
    Illuminate\Contracts\Debug\ExceptionHandler::class,
    App\Exceptions\Handler::class
);
```

������࿴һ�£�����һ��`render`�������ðɣ��ҵ����������ˣ��޸�һ������������ɡ�

```php
public function render($request, Exception $e)
{
    return parent::render($request, $e);
}
```

## �����޸�

����Laravel�Ѿ���ʵ���ˣ���������ķ������Ǹ����������`render`�����ж����Ƿ�Ϊ`HttpException`, ����ǣ���ȥ`errors`Ŀ¼���Ҷ�Ӧstatus code��view������ҵ�������Ⱦ�����������ô�򵥡��޸�`Handler`���£�

```php
/**
 * Render an exception into an HTTP response.
 *
 * @param  \Illuminate\Http\Request  $request
 * @param  \Exception  $e
 * @return \Illuminate\Http\Response
 */
public function render($request, Exception $e)
{
    if( !env('APP_DEBUG') and $this->isHttpException($e)) {
        return $this->renderHttpException($e);
    }
    return parent::render($request, $e);
}

/**
 * Render the given HttpException.
 *
 * @param  \Symfony\Component\HttpKernel\Exception\HttpException  $e
 * @return \Symfony\Component\HttpFoundation\Response
 */
protected function renderHttpException(HttpException $e)
{
    $status = $e->getStatusCode();

    if (view()->exists("errors.{$status}"))
    {
        return response(view("errors.{$status}", []), $status);
    }
    else
    {
        return (new SymfonyExceptionHandler(env('APP_DEBUG', false)))->createResponse($e);
    }
}

/**
 * Determine if the given exception is an HTTP exception.
 *
 * @param  \Exception  $e
 * @return bool
 */
protected function isHttpException(Exception $e)
{
    return $e instanceof HttpException;
}
```

���ˣ���`errors`Ŀ¼���½�һ��`404.blade.php`�ļ�����controller�г��� `abort(404)`��һ�°ɡ�