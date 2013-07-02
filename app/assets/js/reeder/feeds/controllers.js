angular.module('reeder.controllers', []).
  controller('IndexController', function IndexController($scope, $cookies, $http) {
    var url = "/api/posts";

    $http.get(url).success(function(resp) {
      $scope.page        = resp.page;
      $scope.total_pages = resp.total_pages;
      $scope.posts       = resp.records;
    });
  }).

  controller('BookmarkedPostsController', function BookmarkedPostsController($scope, $cookies, $http) {
    var url = "/api/posts?bookmarked=true";

    $http.get(url).success(function(resp) {
      $scope.page        = resp.page;
      $scope.total_pages = resp.total_pages;
      $scope.posts       = resp.records;
    });
  }).

  controller('SearchController', function SearchController($scope, $cookies, $http) {
    $scope.search_posts = function() {
      var url = "/api/posts/search";
      url += "&query=" + $scope.search_query;

      $http.get(url).success(function(resp) {
        $scope.page        = resp.page;
        $scope.total_pages = resp.total_pages;
        $scope.posts       = resp.records;
      });
    }
  }).

  controller('FeedsController', function FeedsController($scope, $cookies, $http) {
    $scope.delete_feed = function(id) {
      $http.delete("/api/feeds/" + id).
        success(function(data, status) {
          if (data.deleted) {
            alert('Deleted');
          }
        });
    };

    $http.get("/api/feeds").success(function(resp) {
      $scope.feeds = resp;
    });
  }).

  controller('FeedController', function FeedController($scope, $http, $route, $cookies, $routeParams) {
    var feed_id = $routeParams.feed_id;

    $("a.feed").removeClass('active');
    $("a.feed[data-id=" + feed_id + "]").addClass('active');

    $http.get("/api/feeds/" + feed_id).success(function(resp) {
      $scope.feed = resp;

      $http.get("/api/feeds/" + feed_id + "/posts").success(function(resp) {
        $scope.posts_count  = resp.total_entries;
        $scope.current_page = resp.page;
        $scope.posts        = resp.records;
      });
    });
  }).

  controller('FeedImportController', function FeedImportController($scope, $cookies, $http) {
    $scope.import_feed = function() {
      var url = prompt('Enter feed URL');
      var params = { url: url };

      $http.post("/api/feeds/import", params).
        success(function(data, status) {
          console.log(data);
        });
    }
  }).

  controller('FeedNavigationController', function FeedNavigationController($scope, $http) {
    $scope.view_full = function() {
      $("#main").removeClass('condensed');
      $("#view_full").addClass('active');
      $("#view_condensed").removeClass('active');
    }

    $scope.view_condensed = function() {
      $("#main").addClass('condensed');
      $("#view_condensed").addClass('active');
      $("#view_full").removeClass('active');
    }
  }).

  controller('PostController', function PostController($scope, $cookies,$http) {
    $scope.bookmark = function(post_id) {
      $scope.post_id = post_id;
      var url = "/api/posts/" + post_id + "/bookmark";

      $http.post(url).
        success(function(data, status) {
          $("#star_" + $scope.post_id).addClass('active');
          alert('Post has been bookmarked');
        });
    };
  }).

  controller('UserController', function UserController($scope, $location, $cookies) {
    $scope.signout = function() {
      delete $cookies.api_token;
      $location.path("/");
    }
  });
