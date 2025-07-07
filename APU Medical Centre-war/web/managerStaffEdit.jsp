<div class="modal-body">
    <input type="hidden" id="editId" name="id">
    <div class="form-group">
        <label for="editName">Name</label>
        <input type="text" class="form-control" id="editName" name="name" required>
    </div>
    <div class="form-group">
        <label for="editEmail">Email</label>
        <input type="email" class="form-control" id="editEmail" name="email" required>
    </div>
    <div class="form-group">
        <label for="editPhone">Phone</label>
        <input type="text" class="form-control" id="editPhone" name="phone" required>
    </div>
    <div class="form-group">
        <label for="editRole">Role</label>
        <input type="text" class="form-control" id="editRole" name="role" required>
    </div>
    <div class="form-group">
        <label for="editDepartment">Department</label>
        <input type="text" class="form-control" id="editDepartment" name="department" required>
    </div>
    <div class="form-group">
        <label for="editStatus">Status</label>
        <select class="form-control" id="editStatus" name="status" required>
            <option value="Active">Active</option>
            <option value="Inactive">Inactive</option>
        </select>
    </div>
    <div class="form-group">
        <label for="editJoinDate">Join Date</label>
        <input type="date" class="form-control" id="editJoinDate" name="joinDate" required>
    </div>
    <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-dark">Save Changes</button>
    </div>
</div>
