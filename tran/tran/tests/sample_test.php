<?php

test('health endpoint returns ok', function () {
    $response = $this->get('/api/health');
    $response->assertStatus(200);
});