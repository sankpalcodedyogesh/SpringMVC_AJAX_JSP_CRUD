<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <h3 class="text-center">Login</h3>
            <form action="doLogin" method="post">
                <div class="mb-3">
                    <label>Username</label>
                    <input type="text" name="username" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required/>
                </div>
                <div class="d-grid">
                    <button class="btn btn-primary" type="submit">Login</button>
                </div>
                <div class="text-center mt-2">
                    <a href="signup">Don't have an account? Sign up</a>
                </div>
                <div class="text-danger text-center mt-2">
                    ${error}
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
