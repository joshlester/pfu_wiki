
# API Design
<br>

## Extend response objects
Example

1. Standard call
/v1/users/{user_id}
**Response**
```
{
	object: "user"
	user_id: 123,
  name_first: "John"
  name_last: "Smith"
  age: 41
}
```

2. Extend call
/v1/users/{user_id}?extend=posts
**Response**
```
{
	user_id: 123,
  name_first: "John"
  name_last: "Smith"
  age: 41,
  posts: {
  	object: "post[]",
    data: [
    	{...},
      {...},
      {...}
    ]
  }
}
```

The extends feature should be implemented with the following in mind:
 - The 'user' data is source via a User Service.
 - The 'posts' data is sourced via a 'Post Service'.
 - Services should be accessible using a unique identify passed to a centeral provider
 e.g. a Slim container or an injector.
 
