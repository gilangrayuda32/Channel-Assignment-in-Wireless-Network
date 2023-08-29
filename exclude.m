function x = exclude(x,indx,rc)

if nargin < 3
    rc = 'col';
end
if size(x,1)==1
    rc = 'col';
elseif size(x,2)==1
    rc = 'row';
end
if strcmp(rc,'col') || strcmp(rc,'column')
    x(:,indx) = [];
elseif strcmp(rc,'row')
    x(indx,:) = [];
end
